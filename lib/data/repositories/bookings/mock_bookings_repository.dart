import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/booking_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/model/booking.dart';

class MockBookingsRepository extends ChangeNotifier
    implements BookingsRepository {
  final List<BookingDto> _bookings = List<BookingDto>.from(MockData.bookings);

  @override
  Future<List<Booking>> getBookingsForUser(String userId) async {
    final list = _bookings.where((item) => item.userId == userId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.map((booking) => booking.toModel()).toList();
  }
}
