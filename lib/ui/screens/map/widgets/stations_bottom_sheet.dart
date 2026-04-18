import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';

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
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.r20),
          topRight: Radius.circular(AppSpacing.r20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.s12),
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s5,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(AppSpacing.r2),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: AppSpacing.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pedal_bike,
                      color: AppColors.primary,
                      size: AppSpacing.lg,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${stations.length} ${loc.get('available')}',
                      style: AppTextStyles.title,
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
          const SizedBox(height: AppSpacing.s12),
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.symmetric(horizontal: AppSpacing.s12),
              itemCount: stations.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final station = stations[index];
                final isSelected = selectedStation?.name == station.name;
                final availableSlots = availableSlotsByStation[station.id] ?? 0;

                return GestureDetector(
                  onTap: () {
                    onStationSelected(station);
                  },
                  child: _buildStationCard(station, isSelected, loc, availableSlots),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
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
      padding: AppSpacing.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight : AppColors.gray50,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray200,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.r8),
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
            child: const Icon(
              Icons.pedal_bike,
              color: AppColors.primary,
              size: AppSpacing.s20,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${station.bikes} ${loc.get('bikes')} • $availableSlots ${loc.get('slots')} • ${station.address}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$distanceKm ${loc.get('km')}',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }
}
