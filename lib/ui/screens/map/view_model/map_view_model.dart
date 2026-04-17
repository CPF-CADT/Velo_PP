import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BookingsRepository _bookingsRepository;
  final StationsRepository _stationsRepository;
  final DockRepository _dockRepository;

  AsyncValue<List<Station>> stations = AsyncValue.loading();
  final Map<String, int> _availableSlotsByStation = {};

  MapViewModel({
    required AuthRepository authRepository,
    required BookingsRepository bookingsRepository,
    required StationsRepository stationsRepository,
    required DockRepository dockRepository,
  }) : _authRepository = authRepository,
       _bookingsRepository = bookingsRepository,
       _stationsRepository = stationsRepository,
       _dockRepository = dockRepository;

  bool get hasActiveRide {
    return _bookingsRepository.hasActiveBookingForUser(
      _authRepository.currentUser.id,
    );
  }

  bool shouldShowStation(Station station) {
    if (hasActiveRide) {
      return getAvailableSlotsForStation(station.id) > 0;
    }
    return station.bikesAvailable > 0;
  }

  int getAvailableSlotsForStation(String stationId) {
    return _availableSlotsByStation[stationId] ?? 0;
  }

  Map<String, int> getAvailableSlotsMap() {
    return _availableSlotsByStation;
  }

  Future<void> loadStations() async {
    stations = AsyncValue.loading();
    notifyListeners();

    try {
      final data = _stationsRepository.getStations();
      stations = AsyncValue.success(data);

      for (final station in data) {
        final docks = await _dockRepository.getDocksByStationId(station.id);
        _availableSlotsByStation[station.id] = docks
            .where((dock) => dock.status == 'available')
            .length;
      }
      notifyListeners();
    } catch (e) {
      stations = AsyncValue.error(e);
    }

    notifyListeners();
  }
}
