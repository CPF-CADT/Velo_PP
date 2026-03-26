import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PassesScreen extends StatelessWidget {
  const PassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.style, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            loc.get('yourPasses'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            loc.get('noPassesYet'),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
