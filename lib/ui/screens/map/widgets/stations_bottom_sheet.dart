import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/screens/station/station_screen.dart';

class StationsBottomSheet extends StatelessWidget {
  final List<Station> stations;
  final Station? selectedStation;
  final LatLng userLocation;
  final Function(Station) onStationSelected;
  final Map<String, int> availableSlotsByStation;

  const StationsBottomSheet({
    super.key,
    required this.stations,
    required this.selectedStation,
    required this.userLocation,
    required this.onStationSelected,
    required this.availableSlotsByStation,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pedal_bike, color: Colors.teal, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${stations.length} ${loc.get('available')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: stations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final station = stations[index];
                final isSelected = selectedStation?.name == station.name;
                final availableSlots = availableSlotsByStation[station.id] ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StationScreen(
                          stationId: station.id,
                          stationName: station.name,
                        ),
                      ),
                    );
                  },
                  child: _buildStationCard(station, isSelected, loc, availableSlots),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStationCard(
    Station station,
    bool isSelected,
    AppLocalizations loc,
    int availableSlots,
  ) {
    final distance = CustomDistanceCalculator.calculateDistance(
      userLocation,
      station.location,
    );
    final distanceKm = CustomDistanceCalculator.formatDistance(distance);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[50] : Colors.grey[50],
        border: Border.all(color: isSelected ? Colors.teal : Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal[100],
            ),
            child: const Icon(Icons.pedal_bike, color: Colors.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${station.bikes} ${loc.get('bikes')} • $availableSlots ${loc.get('slots')} • ${station.address}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '$distanceKm ${loc.get('km')}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
