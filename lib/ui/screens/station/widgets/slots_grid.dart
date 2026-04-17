import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';
import 'slot_card.dart';

class SlotsGrid extends StatelessWidget {
  final List<Dock> slots;
  final Function(String) onSlotTap;

  const SlotsGrid({
    super.key,
    required this.slots,
    required this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No slots available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
        );
      },
    );
  }
}
