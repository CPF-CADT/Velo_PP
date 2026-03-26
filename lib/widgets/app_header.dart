import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'language_toggle.dart';

class AppHeader extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final String currentLanguage;
  final Function(String) onSearchChanged;

  const AppHeader({
    super.key,
    required this.onLocaleChange,
    required this.currentLanguage,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Language Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.get('appTitle'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                LanguageToggle(
                  onLocaleChange: onLocaleChange,
                  currentLanguage: currentLanguage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
