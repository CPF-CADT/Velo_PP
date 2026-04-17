import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';
import 'package:velo_pp/ui/screens/station/widgets/slots_grid.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

class StationContent extends StatefulWidget {
  final Station station;

  const StationContent({
    super.key,
    required this.station,
  });

  @override
  State<StationContent> createState() => _StationContentState();
}

class _StationContentState extends State<StationContent> {
  Dock? _lastReleasedBike;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Consumer<StationViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.slots.state == AsyncValueState.loading) {
          Future.microtask(() => viewModel.loadSlots(widget.station.id));
        }

        if (viewModel.slots.state == AsyncValueState.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.station.name),
              backgroundColor: Colors.teal,
              centerTitle: true,
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          );
        }

        if (viewModel.slots.state == AsyncValueState.error) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.station.name),
              backgroundColor: Colors.teal,
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${loc.get('error')}: ${viewModel.slots.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadSlots(widget.station.id),
                    child: Text(loc.get('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        final slots = viewModel.slots.data ?? [];
        final availableSlots = slots.where((slot) => slot.status == 'available').length;
        final occupiedSlots = slots.where((slot) => slot.status == 'occupied').length;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.station.name),
            backgroundColor: Colors.teal,
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Text(
                  'Current Selection',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.station.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Live Dock Status section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bike Occupied',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$occupiedSlots ${loc.get('bikes')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Available Slots',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$availableSlots ${loc.get('slots')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Slots list
                Expanded(
                  child: SlotsGrid(
                    slots: slots,
                    onSlotTap: (dockId) {
                      _showSlotDetails(context, dockId, viewModel, slots);
                    },
                    onSlotDismiss: (dock) {
                      // Update state immediately
                      setState(() => _lastReleasedBike = dock);
                      
                      // Remove from viewModel's slots list immediately for UI
                      viewModel.removeDockFromList(dock.id);
                      
                      // Update dock status in background
                      viewModel.updateSlotStatus(dock.id, 'available');
                    },
                    lastReleasedBike: _lastReleasedBike,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSlotDetails(
    BuildContext context,
    String dockId,
    StationViewModel viewModel,
    List<Dock> slots,
  ) {
    final loc = AppLocalizations.of(context);
    final slot = slots.where((s) => s.id == dockId).firstOrNull;

    if (slot == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${loc.get('slot')} ${slot.slotNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.info,
                    loc.get('status'),
                    slot.status,
                  ),
                  const SizedBox(height: 12),
                  if (slot.bikeId.isNotEmpty)
                    _buildInfoRow(
                      Icons.pedal_bike,
                      loc.get('bikeId'),
                      slot.bikeId,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
