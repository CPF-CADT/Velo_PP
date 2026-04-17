import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';

class SlotCard extends StatelessWidget {
  final Dock slot;
  final VoidCallback onTap;
  final Function(Dock)? onDismiss;
  final Dock? lastReleasedBike;

  const SlotCard({
    super.key,
    required this.slot,
    required this.onTap,
    this.onDismiss,
    this.lastReleasedBike,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = slot.status == 'occupied';

    if (isOccupied) {
      return Dismissible(
        key: Key(slot.id),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          // Validate before allowing dismissal
          if (lastReleasedBike != null && lastReleasedBike!.id != slot.id) {
            // Show failure alert for trying to release second bike
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'You can only use one bike at a time. Undo the previous bike first.',
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red[700],
                ),
              );
            }
            return false; // Prevent dismissal
          }
          return true; // Allow dismissal
        },
        onDismissed: (direction) {
          // FIRST: Call parent to remove widget from tree immediately
          onDismiss?.call(slot);

          // SECOND: Show feedback AFTER parent removes widget
          // Use addPostFrameCallback to ensure rebuild is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${slot.bikeId} has been released'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green[700],
                ),
              );
            }
          });
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 28,
          ),
        ),
        child: _buildSlotCard(isOccupied),
      );
    }

    return _buildSlotCard(isOccupied);
  }

  Widget _buildSlotCard(bool isOccupied) {
    final bgColor = isOccupied ? Colors.teal[50] : Colors.grey[50];
    final borderColor = isOccupied ? Colors.teal : Colors.grey[300];

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
                      'Bike: ${slot.bikeId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOccupied ? Colors.teal : Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                slot.status,
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
