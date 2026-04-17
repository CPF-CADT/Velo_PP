import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

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
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppSpacing.r20),
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
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.r18),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
