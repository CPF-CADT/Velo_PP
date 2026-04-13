import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/model/bike.dart';
import 'package:velo_pp/model/booking.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/async_value.dart';

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

class RidesViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BookingsRepository _bookingsRepository;
  final StationsRepository _stationsRepository;
  final BikesRepository _bikesRepository;

  AsyncValue<List<RideSummary>> rides = AsyncValue.loading();

  RidesViewModel({
    required AuthRepository authRepository,
    required BookingsRepository bookingsRepository,
    required StationsRepository stationsRepository,
    required BikesRepository bikesRepository,
  }) : _authRepository = authRepository,
       _bookingsRepository = bookingsRepository,
       _stationsRepository = stationsRepository,
       _bikesRepository = bikesRepository;

  Future<void> loadRides() async {
    rides = AsyncValue.loading();
    notifyListeners();

    try {
      final user = _authRepository.currentUser;
      final bookings = _bookingsRepository.getBookingsForUser(user.id);
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
}
