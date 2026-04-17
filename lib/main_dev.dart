// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

// import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
// import 'package:velo_pp/data/repositories/auth/mock_auth_repository.dart';
// import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
// import 'package:velo_pp/data/repositories/bikes/bike_repository_firebase.dart';
// import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
// import 'package:velo_pp/data/repositories/bookings/mock_bookings_repository.dart';
// import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
// import 'package:velo_pp/data/repositories/dock/dock_repository_firebase.dart';
// import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
// import 'package:velo_pp/data/repositories/passes/mock_passes_repository.dart';
// import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
// import 'package:velo_pp/data/repositories/stations/station_repository_firebase.dart';

// import 'package:velo_pp/main_common.dart';
// import 'package:velo_pp/services/station_service.dart';
// import 'package:velo_pp/ui/states/app_settings_state.dart';

// import 'firebase_options.dart';

// /// Configure provider dependencies for dev environment.
// List<InheritedProvider> get devProviders {
//   return [
//     ChangeNotifierProvider<AppSettingsState>(create: (_) => AppSettingsState()),

//     ChangeNotifierProvider<AuthRepository>(create: (_) => MockAuthRepository()),

//     ChangeNotifierProvider<StationsRepository>(
//       create: (_) => FirebaseStationsRepository(),
//     ),

//     Provider<StationGeographyService>(
//       create: (_) => const MockStationGeographyService(),
//     ),

//     ChangeNotifierProvider<BikesRepository>(
//       create: (_) => FirebaseBikesRepository(),
//     ),

//     ChangeNotifierProvider<PassesRepository>(
//       create: (_) => MockPassesRepository(),
//     ),

//     ChangeNotifierProvider<BookingsRepository>(
//       create: (_) => MockBookingsRepository(),
//     ),

//     ChangeNotifierProvider<DockRepository>(
//       create: (_) => FirebaseDockRepository(),
//     ),
//   ];
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runDevApp();
// }

// void runDevApp() {
//   mainCommon(devProviders);
// }
