import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/services/location_service.dart';
import 'package:velo_pp/model/bike.dart';
import 'package:velo_pp/model/booking.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:latlong2/latlong.dart';

class RideSummary {
  final Booking booking;
  final Bike? bike;
  final Station? startStation;
  final Station? endStation;

  const RideSummary({
    required this.booking,
    required this.bike,
    required this.startStation,
    required this.endStation,
  });
}

class ReturnResult {
  final Station station;
  final Dock dock;

  const ReturnResult({required this.station, required this.dock});
}

class RidesViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BookingsRepository _bookingsRepository;
  final StationsRepository _stationsRepository;
  final BikesRepository _bikesRepository;
  final DockRepository _dockRepository;

  final Set<String> _returningBookingIds = <String>{};
  bool _isReloading = false;

  AsyncValue<List<RideSummary>> rides = AsyncValue.loading();

  RidesViewModel({
    required AuthRepository authRepository,
    required BookingsRepository bookingsRepository,
    required StationsRepository stationsRepository,
    required BikesRepository bikesRepository,
    required DockRepository dockRepository,
  }) : _authRepository = authRepository,
       _bookingsRepository = bookingsRepository,
       _stationsRepository = stationsRepository,
       _bikesRepository = bikesRepository,
       _dockRepository = dockRepository {
    _bookingsRepository.addListener(_onRepositoryChanged);
    _bikesRepository.addListener(_onRepositoryChanged);
    _stationsRepository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    if (_isReloading) {
      return;
    }
    _isReloading = true;
    loadRides().whenComplete(() {
      _isReloading = false;
    });
  }

  Future<void> loadRides() async {
    rides = AsyncValue.loading();
    notifyListeners();

    try {
      final user = _authRepository.currentUser;
      final bookings = await _bookingsRepository.getBookingsForUser(user.id);
      final summaries = bookings
          .map(
            (booking) => RideSummary(
              booking: booking,
              bike: _bikesRepository.getBikeById(booking.bikeId),
              startStation: _stationsRepository.getStationById(
                booking.startStationId,
              ),
              endStation: _stationsRepository.getStationById(
                booking.endStationId,
              ),
            ),
          )
          .toList();
      rides = AsyncValue.success(summaries);
    } catch (e) {
      rides = AsyncValue.error(e);
    }

    notifyListeners();
  }

  bool isReturning(String bookingId) {
    return _returningBookingIds.contains(bookingId);
  }

  Future<ReturnResult> returnBike(RideSummary summary) async {
    final bookingId = summary.booking.id;
    if (_returningBookingIds.contains(bookingId)) {
      throw Exception('Return already in progress');
    }

    _returningBookingIds.add(bookingId);
    notifyListeners();

    try {
      final serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      final permission = await LocationService.requestLocationPermission();
      if (LocationService.isPermissionDenied(permission)) {
        throw Exception('Location permission denied');
      }

      final currentLocation = await LocationService.getCurrentLocation();
      if (currentLocation == null) {
        throw Exception('Unable to read current location');
      }

      final stations = _stationsRepository.getStations();
      if (stations.isEmpty) {
        throw Exception('No stations available');
      }

      final nearest = await _findNearestStationWithSlot(
        currentLocation,
        stations,
      );
      if (nearest == null) {
        throw Exception('No available slot nearby');
      }

      await _dockRepository.assignBikeToDock(
        dockId: nearest.dock.id,
        bikeId: summary.booking.bikeId,
      );
      await _bikesRepository.updateBikeStatus(
        summary.booking.bikeId,
        'available',
      );
      await _bookingsRepository.completeBooking(
        bookingId: bookingId,
        endStationId: nearest.station.id,
      );

      await loadRides();
      return ReturnResult(station: nearest.station, dock: nearest.dock);
    } finally {
      _returningBookingIds.remove(bookingId);
      notifyListeners();
    }
  }

  Future<_StationDockMatch?> _findNearestStationWithSlot(
    LatLng userLocation,
    List<Station> stations,
  ) async {
    final distance = const Distance();
    final sortedStations = List<Station>.from(stations)
      ..sort(
        (a, b) => distance(
          a.location,
          userLocation,
        ).compareTo(distance(b.location, userLocation)),
      );

    for (final station in sortedStations) {
      final docks = await _dockRepository.getDocksByStationId(station.id);
      final available = docks.where((dock) => dock.status == 'available');
      if (available.isNotEmpty) {
        return _StationDockMatch(station: station, dock: available.first);
      }
    }

    return null;
  }

  @override
  void dispose() {
    _bookingsRepository.removeListener(_onRepositoryChanged);
    _bikesRepository.removeListener(_onRepositoryChanged);
    _stationsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}

class _StationDockMatch {
  final Station station;
  final Dock dock;

  const _StationDockMatch({required this.station, required this.dock});
}
