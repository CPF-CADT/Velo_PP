import 'package:flutter/material.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/core/widgets/app_button.dart';
import 'package:velo_pp/core/widgets/app_card.dart';

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
    final bgColor = isFeatured ? AppColors.darkSurface : AppColors.white;
    final textColor = isFeatured ? AppColors.white : AppColors.textPrimary;

    return AppCard(
      color: bgColor,
      padding: AppSpacing.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitle.copyWith(color: textColor)),
          const SizedBox(height: AppSpacing.s12),

          Text(
            price,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: isFeatured ? AppColors.gray400 : AppColors.gray600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features.map((feature) {
              return Padding(
                padding: AppSpacing.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: AppSpacing.md,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTextStyles.body.copyWith(
                          color: isFeatured
                              ? AppColors.gray300
                              : AppColors.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.s20),
          Theme(
            data: Theme.of(context).copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFeatured
                      ? AppColors.white
                      : AppColors.success,
                  foregroundColor: isFeatured
                      ? AppColors.textPrimary
                      : AppColors.white,
                ),
              ),
            ),
            child: AppButton(label: buttonLabel, onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
