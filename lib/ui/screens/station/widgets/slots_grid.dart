import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';
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
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No slots available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: slots.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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
