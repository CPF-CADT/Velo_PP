import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final bool isSelected;
  final VoidCallback onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final distance = CustomDistanceCalculator.calculateDistance(
      // This will be passed from parent
      LatLng(0, 0), // Placeholder - should be user location
      station.location,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[50] : Colors.grey[50],
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey[200]!,
          ),
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
                    '${station.bikes} ${loc.get('bikes')} • ${station.address}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              '${CustomDistanceCalculator.formatDistance(distance)} ${loc.get('km')}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
