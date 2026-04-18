import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo_pp/ui/screens/map/widgets/map_content.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class MapScreen extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onQuickReturnTap;
  final VoidCallback onOpenPassesTap;

  const MapScreen({
    super.key,
    required this.onProfileTap,
    required this.onQuickReturnTap,
    required this.onOpenPassesTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapViewModel(
        authRepository: context.read<AuthRepository>(),
        bookingsRepository: context.read<BookingsRepository>(),
        stationsRepository: context.read<StationsRepository>(),
        dockRepository: context.read<DockRepository>(),
        rideState: context.read<RideState>(),
      ),
      child: MapContent(
        onProfileTap: onProfileTap,
        onQuickReturnTap: onQuickReturnTap,
        onOpenPassesTap: onOpenPassesTap,
      ),
    );
  }
}
