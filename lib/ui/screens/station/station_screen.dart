import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/ui/screens/station/content/station_content.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';
import 'package:velo_pp/model/station.dart';

class StationScreen extends StatelessWidget {
  final Station station;
  final VoidCallback? onOpenPassesTap;

  const StationScreen({super.key, required this.station, this.onOpenPassesTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StationViewModel(
        authRepository: context.read<AuthRepository>(),
        bikesRepository: context.read<BikesRepository>(),
        bookingsRepository: context.read<BookingsRepository>(),
        dockRepository: context.read<DockRepository>(),
        passesRepository: context.read<PassesRepository>(),
      ),
      child: StationContent(station: station, onOpenPassesTap: onOpenPassesTap),
    );
  }
}
