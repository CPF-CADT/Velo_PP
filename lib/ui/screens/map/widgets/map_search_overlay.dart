import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/search_bar.dart';

class MapSearchOverlay extends StatelessWidget {
  final VoidCallback onProfileTap;
  final Function(String) onSearchChanged;

  const MapSearchOverlay({
    super.key,
    required this.onProfileTap,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Profile Avatar
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
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onProfileTap,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white, size: 18),
                    ),
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
