import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AppHeader({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      color: AppColors.surface,
      padding: AppSpacing.fromLTRB(
        AppSpacing.md,
        AppSpacing.s12,
        AppSpacing.md,
        AppSpacing.s12,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Profile Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.get('appTitle'),
                  style: AppTextStyles.title.copyWith(color: AppColors.primary),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.r20),
                  onTap: onProfileTap,
                  child: const CircleAvatar(
                    radius: AppSpacing.s18,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: AppSpacing.s18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
