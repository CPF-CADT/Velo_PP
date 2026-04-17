import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/ui/screens/station/content/station_content.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';
import 'package:velo_pp/model/station.dart';

class StationScreen extends StatelessWidget {
  final Station station;

  const StationScreen({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StationViewModel(dockRepository: context.read<DockRepository>()),
      child: StationContent(
        station: station,
      ),
    );
  }
}
