import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/screens/station/station_screen.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';

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
      padding: AppSpacing.all(AppSpacing.s20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.r20),
          topRight: Radius.circular(AppSpacing.r20),
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
                style: AppTextStyles.title,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: AppSpacing.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppSpacing.r8),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.location_on, loc.get('location')),
                const SizedBox(height: AppSpacing.s12),
                _buildInfoRow(
                  Icons.pedal_bike,
                  '$availableBikes ${loc.get('bikesAvailable')}',
                ),
                const SizedBox(height: AppSpacing.s12),
                _buildInfoRow(
                  Icons.straighten,
                  '$distanceKm ${loc.get('km')} ${loc.get('away')}',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: AppSpacing.symmetric(vertical: AppSpacing.s12),
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
                style: AppTextStyles.subtitle.copyWith(color: AppColors.white),
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
        Icon(icon, color: AppColors.primary, size: AppSpacing.s20),
        const SizedBox(width: AppSpacing.s12),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}
