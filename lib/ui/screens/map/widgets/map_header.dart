import 'package:flutter/material.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/ui/widgets/language_toggle.dart';

class MapHeader extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final String currentLanguage;
  final Function(String) onSearchChanged;

  const MapHeader({
    super.key,
    required this.onLocaleChange,
    required this.currentLanguage,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.get('appTitle'),
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  LanguageToggle(
                    onLocaleChange: onLocaleChange,
                    currentLanguage: currentLanguage,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              SearchBar(
                onChanged: onSearchChanged,
                hintText: loc.get('searchHint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
