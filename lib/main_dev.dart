import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/auth/mock_auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository_firebase.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository_firebase.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository_firebase.dart';
import 'package:velo_pp/data/repositories/passes/pass_repository_firebase.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository_firebase.dart';



import 'package:velo_pp/main_common.dart';
import 'package:velo_pp/services/station_service.dart';
import 'package:velo_pp/ui/states/app_settings_state.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

import 'firebase_options.dart';

/// Configure provider dependencies for dev environment.
/// Configure provider dependencies for dev environment.
List<InheritedProvider> devProviders({
  required FirebaseBikesRepository bikesRepository,
  required FirebasePassesRepository passesRepository,
  required FirebaseBookingsRepository bookingsRepository,
  required FirebaseStationsRepository stationsRepository,
  required FirebaseDockRepository dockRepository,
}) {
  return [
    ChangeNotifierProvider<AppSettingsState>(create: (_) => AppSettingsState()),
    ChangeNotifierProvider<RideState>(create: (_) => RideState()),
    Provider<AuthRepository>(create: (_) => MockAuthRepository()),
    Provider<StationsRepository>(
      create: (_) => stationsRepository,
    ),
    Provider<StationGeographyService>(
      create: (_) => const MockStationGeographyService(),
    ),
    Provider<BikesRepository>(
      create: (_) => bikesRepository,
    ),
    Provider<PassesRepository>(
      create: (_) => passesRepository,
    ),
    Provider<BookingsRepository>(
      create: (_) => bookingsRepository,
    ),
    Provider<DockRepository>(
      create: (_) => dockRepository,
    ),
  ];
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize all Firebase repositories
  final passesRepository = FirebasePassesRepository();
  await passesRepository.loadInitialData();

  final bookingsRepository = FirebaseBookingsRepository();
  await bookingsRepository.loadInitialData();

  final stationsRepository = FirebaseStationsRepository();
  await stationsRepository.loadInitialData();

  final bikesRepository = FirebaseBikesRepository();
  await bikesRepository.loadInitialData();

  final dockRepository = FirebaseDockRepository();
  await dockRepository.loadInitialData();
  
 

  runDevApp(
    bikesRepository,
    passesRepository,
    bookingsRepository,
    stationsRepository,
    dockRepository,
  );
}

void runDevApp(
  FirebaseBikesRepository bikesRepository,
  FirebasePassesRepository passesRepository,
  FirebaseBookingsRepository bookingsRepository,
  FirebaseStationsRepository stationsRepository,
  FirebaseDockRepository dockRepository,
) {
  mainCommon(devProviders(
    bikesRepository: bikesRepository,
    passesRepository: passesRepository,
    bookingsRepository: bookingsRepository,
    stationsRepository: stationsRepository,
    dockRepository: dockRepository,
  ));
}