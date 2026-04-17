import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';

class SlotCard extends StatelessWidget {
  final Dock slot;
  final VoidCallback onTap;
  final Future<void> Function()? onDismiss;
  final String bikeLabel;
  final bool isSelected;

  const SlotCard({
    super.key,
    required this.slot,
    required this.onTap,
    this.onDismiss,
    required this.bikeLabel,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = slot.status == 'occupied';

    if (!isOccupied) {
      return _buildSlotCard(isOccupied);
    }

    return Dismissible(
      key: ValueKey('slot_select_${slot.id}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (_) async {
        if (onDismiss != null) {
          await onDismiss!();
        } else {
          onTap();
        }
        return false;
      },
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        icon: Icons.swipe_right_alt,
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        icon: Icons.swipe_left_alt,
      ),
      child: _buildSlotCard(isOccupied),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.withAlpha(AppColors.primary, 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.r8),
      ),
      alignment: alignment,
      padding: AppSpacing.symmetric(horizontal: AppSpacing.md),
      child: Icon(icon, color: AppColors.primary, size: AppSpacing.s22),
    );
  }

  Widget _buildSlotCard(bool isOccupied) {
    final bgColor = isSelected
        ? AppColors.primaryLight
        : (isOccupied ? AppColors.primaryLight : AppColors.gray50);
    final borderColor = isSelected
        ? AppColors.primary
        : (isOccupied ? AppColors.primary : AppColors.gray300);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppSpacing.r8),
        ),
        child: Row(
          children: [
            Icon(
              isOccupied ? Icons.pedal_bike : Icons.clear,
              size: AppSpacing.xl,
              color: isOccupied ? AppColors.primary : AppColors.gray400,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slot ${slot.slotNumber}',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (slot.bikeId.isNotEmpty)
                    Text(
                      'Bike: $bikeLabel',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isOccupied ? AppColors.primary : AppColors.gray400),
                borderRadius: BorderRadius.circular(AppSpacing.r20),
              ),
              child: Text(
                isSelected ? 'selected' : slot.status,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
