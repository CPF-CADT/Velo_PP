import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/screens/station/station_screen.dart';

class StationModal extends StatelessWidget {
  final Station station;
  final LatLng userLocation;
  final VoidCallback? onSelect;

  const StationModal({
    super.key,
    required this.station,
    required this.userLocation,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final distance = CustomDistanceCalculator.calculateDistance(
      userLocation,
      station.location,
    );
    final distanceKm = CustomDistanceCalculator.formatDistance(distance);
    final repo = context.watch<BikesRepository>();
    final availableBikesFromRepo = repo
        .getAvailableBikesForStation(station.id)
        .length;
    final availableBikes = availableBikesFromRepo > 0
        ? availableBikesFromRepo
        : station.bikesAvailable;

    return Container(
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
                station.name,
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
                _buildInfoRow(Icons.location_on, loc.get('location')),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.pedal_bike,
                  '$availableBikes ${loc.get('bikesAvailable')}',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.straighten,
                  '$distanceKm ${loc.get('km')} ${loc.get('away')}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationScreen(
                      station: station,
                    ),
                  ),
                );
              },
              child: Text(
                loc.get('select'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
