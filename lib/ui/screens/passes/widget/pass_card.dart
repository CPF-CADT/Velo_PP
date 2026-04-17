import 'package:flutter/material.dart';

class PassCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool isFeatured;

  const PassCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonLabel,
    required this.onPressed,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
   
    Color bgColor = isFeatured ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5);
    Color textColor = isFeatured ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    // Title
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
          const SizedBox(height: 12),

    // Price
          Text(price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF00D084))),
          const SizedBox(height: 4),

      // Description
          Text(description, style: TextStyle(fontSize: 12, color: isFeatured ? Colors.grey[400] : Colors.grey[600])),
          const SizedBox(height: 16),

      // Features List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Color(0xFF00D084)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature, style: TextStyle(fontSize: 13, color: isFeatured ? Colors.grey[300] : Colors.grey[700]))),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFeatured ? Colors.white : const Color(0xFF00D084),
                foregroundColor: isFeatured ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(buttonLabel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
