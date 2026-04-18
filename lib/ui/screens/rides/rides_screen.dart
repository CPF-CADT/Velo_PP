import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/ui/screens/rides/view_model/rides_view_model.dart';
import 'package:velo_pp/ui/screens/rides/widgets/ride_content.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class RideScreen extends StatelessWidget {
  const RideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RidesViewModel(
        authRepository: context.read<AuthRepository>(),
        bookingsRepository: context.read<BookingsRepository>(),
        stationsRepository: context.read<StationsRepository>(),
        bikesRepository: context.read<BikesRepository>(),
        dockRepository: context.read<DockRepository>(),
        rideState: context.read<RideState>(),
      )..loadRides(),
      child: const RideContent(),
    );
  }
}

class RidesScreen extends RideScreen {
  const RidesScreen({super.key});
}
