import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'language_toggle.dart';
import 'search_bar.dart';

class MapSearchOverlay extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final String currentLanguage;
  final Function(String) onSearchChanged;

  const MapSearchOverlay({
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
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Language Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      loc.get('appTitle'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  LanguageToggle(
                    onLocaleChange: onLocaleChange,
                    currentLanguage: currentLanguage,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: CustomSearchBar(
                  onChanged: onSearchChanged,
                  hintText: loc.get('searchHint'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
