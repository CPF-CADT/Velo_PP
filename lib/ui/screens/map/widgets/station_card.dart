import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/distance_calculator.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';

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
                    '${station.bikes} ${loc.get('bikes')} • ${station.address}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${CustomDistanceCalculator.formatDistance(distance)} ${loc.get('km')}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
