import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/auth/mock_auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bikes/mock_bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/bookings/mock_bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository_firebase.dart';
import 'package:velo_pp/data/repositories/passes/pass_repository_firebase.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/data/repositories/stations/mock_stations_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';



import 'package:velo_pp/main_common.dart';
import 'package:velo_pp/services/station_service.dart';
import 'package:velo_pp/ui/states/app_settings_state.dart';

import 'firebase_options.dart';
import 'package:velo_pp/data/mock/firebase_seed.dart';

/// Configure provider dependencies for dev environment.
/// Configure provider dependencies for dev environment.
List<InheritedProvider> devProviders({
  required FirebasePassesRepository passesRepository,
  required FirebaseDockRepository dockRepository,
}) {
  return [
    ChangeNotifierProvider<AppSettingsState>(create: (_) => AppSettingsState()),
    ChangeNotifierProvider<AuthRepository>(create: (_) => MockAuthRepository()),
    ChangeNotifierProvider<StationsRepository>(
      create: (_) => MockStationsRepository(),
    ),
    Provider<StationGeographyService>(
      create: (_) => const MockStationGeographyService(),
    ),
    ChangeNotifierProvider<BikesRepository>(
      create: (_) => MockBikesRepository(),
    ),
    ChangeNotifierProvider<PassesRepository>(
      create: (_) => passesRepository,
    ),
    ChangeNotifierProvider<BookingsRepository>(
      create: (_) => MockBookingsRepository(),
    ),
    ChangeNotifierProvider<DockRepository>(
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

  final dockRepository = FirebaseDockRepository();
 

  runDevApp(passesRepository, dockRepository);
}

void runDevApp(
  FirebasePassesRepository passesRepository,
  FirebaseDockRepository dockRepository,
) {
  mainCommon(devProviders(
    passesRepository: passesRepository,
    dockRepository: dockRepository,
  ));
}