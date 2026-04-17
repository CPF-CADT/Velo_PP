import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/ui/screens/station/content/station_content.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';

class StationScreen extends StatelessWidget {
  final String stationId;
  final String stationName;

  const StationScreen({
    super.key,
    required this.stationId,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StationViewModel(dockRepository: context.read<DockRepository>()),
      child: StationContent(
        stationId: stationId,
        stationName: stationName,
      ),
    );
  }
}
