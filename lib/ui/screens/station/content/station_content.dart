import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';
import 'package:velo_pp/ui/screens/station/widgets/slots_grid.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

class StationContent extends StatefulWidget {
  final Station station;
  final VoidCallback? onOpenPassesTap;

  const StationContent({
    super.key,
    required this.station,
    this.onOpenPassesTap,
  });

  @override
  State<StationContent> createState() => _StationContentState();
}

class _StationContentState extends State<StationContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StationViewModel>().loadSlots(widget.station.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Consumer<StationViewModel>(
      builder: (context, viewModel, _) {
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
        final availableSlots = slots
            .where((slot) => slot.status == 'available')
            .length;
        final occupiedSlots = slots
            .where((slot) => slot.status == 'occupied')
            .length;
        final selectedDock = viewModel.selectedDock;
        final selectedBikeModel = selectedDock == null
            ? null
            : viewModel.getBikeModel(selectedDock.bikeId);
        final hasActiveRide = viewModel.hasActiveRide;

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
                Text(
                  widget.station.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasActiveRide
                      ? 'You already have an active ride. Return it before booking another bike.'
                      : 'Select one occupied slot to book a bike.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                if (hasActiveRide) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Text(
                      'Booking is locked until your current ride is returned.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
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
                Expanded(
                  child: SlotsGrid(
                    slots: slots,
                    selectedDockId: viewModel.selectedDockId,
                    bikeLabelBuilder: (dock) =>
                        viewModel.getBikeModel(dock.bikeId),
                    onSlotDismiss: hasActiveRide
                        ? null
                        : (dockId) =>
                              _bookBikeFromDismiss(context, viewModel, dockId),
                    onSlotTap: hasActiveRide
                        ? (_) {}
                        : (dockId) => viewModel.selectDock(dockId),
                  ),
                ),
                const SizedBox(height: 12),
                if (selectedDock != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.teal.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      'Selected: Slot ${selectedDock.slotNumber} - Bike $selectedBikeModel',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        (hasActiveRide ||
                            selectedDock == null ||
                            viewModel.isBooking)
                        ? null
                        : () => _bookBike(context, viewModel),
                    icon: viewModel.isBooking
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.pedal_bike),
                    label: Text(
                      viewModel.isBooking ? 'Booking...' : 'Book selected bike',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _bookBike(
    BuildContext context,
    StationViewModel viewModel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await viewModel.bookSelectedBike();
      if (!context.mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(content: Text('Bike booked successfully')),
      );
      Navigator.pop(context);
    } on PassRequiredException {
      final action = await _showPassChoiceDialog(context);
      if (action == null || !context.mounted) {
        return;
      }

      if (action == 'single_pass') {
        final paid = await _showSingleTicketPaymentSheet(context);
        if (paid != true || !context.mounted) {
          return;
        }

        try {
          await viewModel.bookSelectedBike(purchasePassId: 'single_pass');
          if (!context.mounted) {
            return;
          }
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Ticket paid and bike booked successfully'),
            ),
          );
          Navigator.pop(context);
        } catch (error) {
          messenger.showSnackBar(SnackBar(content: Text(error.toString())));
        }
        return;
      }

      if (action == 'buy_pass') {
        if (widget.onOpenPassesTap != null) {
          Navigator.pop(context);
          widget.onOpenPassesTap!.call();
          return;
        }

        messenger.showSnackBar(
          const SnackBar(
            content: Text('Pass tab is not available from this entry point'),
          ),
        );
      }
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _bookBikeFromDismiss(
    BuildContext context,
    StationViewModel viewModel,
    String dockId,
  ) async {
    viewModel.selectDock(dockId);
    await _bookBike(context, viewModel);
  }

  Future<String?> _showPassChoiceDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pass Required'),
          content: const Text(
            'You do not have an active pass. Choose an option to continue booking.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'single_pass'),
              child: const Text('Single Ticket'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'buy_pass'),
              child: const Text('Buy Pass'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showSingleTicketPaymentSheet(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Single Ticket Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Complete payment before booking this bike.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Single Ticket',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Pay \$1',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirm Payment'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
