import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_pp/ui/screens/map/widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  final VoidCallback onProfileTap;

  const MapScreen({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapViewModel(
        stationsRepository: context.read<StationsRepository>(),
        dockRepository: context.read<DockRepository>(),
      ),
      child: MapContent(onProfileTap: onProfileTap),
    );
  }
}
