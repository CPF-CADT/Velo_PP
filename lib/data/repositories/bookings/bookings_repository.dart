import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/booking.dart';

abstract class BookingsRepository extends ChangeNotifier {
  List<Booking> getBookingsForUser(String userId);
  Future<Booking> createBooking({
    required String userId,
    required String bikeId,
    required String startStationId,
  });
  bool hasActiveBookingForUser(String userId);
  bool hasActiveBookingForBike(String bikeId);
  Future<void> completeBooking({
    required String bookingId,
    required String endStationId,
  });
}
