import 'package:flutter/material.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/widgets/language_toggle.dart';
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
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
              const SizedBox(height: 12),
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
