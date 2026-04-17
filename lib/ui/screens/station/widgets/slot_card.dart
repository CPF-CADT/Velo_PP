import 'package:flutter/material.dart';
import 'package:velo_pp/model/dock.dart';

class SlotCard extends StatelessWidget {
  final Dock slot;
  final VoidCallback onTap;

  const SlotCard({
    super.key,
    required this.slot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = slot.status == 'occupied';
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
