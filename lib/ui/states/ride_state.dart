import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/booking.dart';

class RideState extends ChangeNotifier {
  Booking? _booking;

  Booking? get booking => _booking;

  void setBooking(Booking booking) {
    _booking = booking;
    notifyListeners();
  }

  void notifyRideBooked(Booking booking) {
    setBooking(booking);
  }

  void clearBooking() {
    _booking = null;
    notifyListeners();
  }

  void notifyRideReturned() {
    clearBooking();
  }
}
