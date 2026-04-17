import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'slot_card.dart';

class SlotsGrid extends StatelessWidget {
  final List<Dock> slots;
  final Function(String) onSlotTap;
  final Future<void> Function(String)? onSlotDismiss;
  final String Function(Dock) bikeLabelBuilder;
  final String? selectedDockId;

  const SlotsGrid({
    super.key,
    required this.slots,
    required this.onSlotTap,
    required this.bikeLabelBuilder,
    this.onSlotDismiss,
    this.selectedDockId,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: AppSpacing.s48,
              color: AppColors.gray400,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'No slots available',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: slots.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.s12),
      itemBuilder: (context, index) {
        final slot = slots[index];
        return SlotCard(
          slot: slot,
          onTap: () => onSlotTap(slot.id),
          onDismiss: onSlotDismiss == null
              ? null
              : () => onSlotDismiss!(slot.id),
          bikeLabel: bikeLabelBuilder(slot),
          isSelected: slot.id == selectedDockId,
        );
      },
    );
  }
}
