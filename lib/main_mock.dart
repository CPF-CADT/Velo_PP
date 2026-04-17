import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/auth/mock_auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bikes/mock_bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/bookings/mock_bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/dock/mock_dock_repository.dart';
import 'package:velo_pp/data/repositories/passes/mock_passes_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/data/repositories/stations/mock_stations_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/main_common.dart';
import 'package:velo_pp/services/station_service.dart';
import 'package:velo_pp/ui/states/app_settings_state.dart';

/// Configure provider dependencies for mock environment.
List<InheritedProvider> get mockProviders {
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
      create: (_) => MockPassesRepository(),
    ),
    ChangeNotifierProvider<BookingsRepository>(
      create: (_) => MockBookingsRepository(),
    ),
    ChangeNotifierProvider<DockRepository>(create: (_) => MockDockRepository()),
  ];
}

void main() {
  runMockApp();
}

void runMockApp() {
  mainCommon(mockProviders);
}
