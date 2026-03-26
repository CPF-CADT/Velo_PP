import 'package:flutter/material.dart';

class LanguageToggle extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final String currentLanguage;

  const LanguageToggle({
    super.key,
    required this.onLocaleChange,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildLanguageButton(
            'EN',
            () => onLocaleChange(const Locale('en')),
            currentLanguage == 'en',
          ),
          _buildLanguageButton(
            'ខ្មែរ',
            () => onLocaleChange(const Locale('km')),
            currentLanguage == 'km',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    String label,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.teal,
          ),
        ),
      ),
    );
  }
}
