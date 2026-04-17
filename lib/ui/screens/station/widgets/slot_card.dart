import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';

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
        color: Colors.teal.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Icon(icon, color: Colors.teal, size: 22),
    );
  }

  Widget _buildSlotCard(bool isOccupied) {
    final bgColor = isSelected
        ? Colors.teal[100]
        : (isOccupied ? Colors.teal[50] : Colors.grey[50]);
    final borderColor = isSelected
        ? Colors.teal[700]
        : (isOccupied ? Colors.teal : Colors.grey[300]);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor!, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isOccupied ? Icons.pedal_bike : Icons.clear,
              size: 32,
              color: isOccupied ? Colors.teal : Colors.grey[400],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slot ${slot.slotNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (slot.bikeId.isNotEmpty)
                    Text(
                      'Bike: $bikeLabel',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.teal[700]
                    : (isOccupied ? Colors.teal : Colors.grey[400]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isSelected ? 'selected' : slot.status,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
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
