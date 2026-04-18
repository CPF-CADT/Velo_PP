import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class MapViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BookingsRepository _bookingsRepository;
  final StationsRepository _stationsRepository;
  final DockRepository _dockRepository;
  final RideState _rideState;

  AsyncValue<List<Station>> stations = AsyncValue.loading();
  final Map<String, int> _availableSlotsByStation = {};

  MapViewModel({
    required AuthRepository authRepository,
    required BookingsRepository bookingsRepository,
    required StationsRepository stationsRepository,
    required DockRepository dockRepository,
    required RideState rideState,
  }) : _authRepository = authRepository,
       _bookingsRepository = bookingsRepository,
       _stationsRepository = stationsRepository,
       _dockRepository = dockRepository,
       _rideState = rideState {
    _rideState.addListener(_onRideStateChanged);
  }

  void _onRideStateChanged() {
    _syncStationsAndSlots(showLoading: false);
  }

  bool get hasActiveRide {
    final booking = _rideState.booking;
    if (booking != null && booking.userId == _authRepository.currentUser.id) {
      return booking.status.toLowerCase() == 'active';
    }

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

  Future<void> _syncStationsAndSlots({required bool showLoading}) async {
    if (showLoading) {
      stations = AsyncValue.loading();
      notifyListeners();
    }

    try {
      final data = _stationsRepository.getStations();
      stations = AsyncValue.success(data);

      _availableSlotsByStation.clear();
      for (final station in data) {
        final docks = await _dockRepository.getDocksByStationId(station.id);
        _availableSlotsByStation[station.id] = docks
            .where((dock) => dock.status == 'available')
            .length;
      }
    } catch (e) {
      stations = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> loadStations() async {
    await _syncStationsAndSlots(showLoading: true);
  }

  @override
  void dispose() {
    _rideState.removeListener(_onRideStateChanged);
    super.dispose();
  }
}
