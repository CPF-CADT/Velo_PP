import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bike, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            loc.get('yourRides'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            loc.get('noRidesYet'),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
