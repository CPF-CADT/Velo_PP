import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/booking.dart';

abstract class BookingsRepository extends ChangeNotifier {
  List<Booking> getBookingsForUser(String userId);
}
