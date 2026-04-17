import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/booking_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/model/booking.dart';

class MockBookingsRepository extends ChangeNotifier
    implements BookingsRepository {
  final List<BookingDto> _bookings = List<BookingDto>.from(MockData.bookings);

  bool _isActiveStatus(String status) {
    return status.trim().toLowerCase() == 'active';
  }

  @override
  List<Booking> getBookingsForUser(String userId) {
    final list = _bookings.where((item) => item.userId == userId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.map((booking) => booking.toModel()).toList();
  }

  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (hasActiveBookingForUser(userId)) {
      throw Exception('You already have an active booking');
    }

    if (hasActiveBookingForBike(bikeId)) {
      throw Exception('This bike is already booked');
    }

    final now = DateTime.now();
    final dto = BookingDto(
      id: 'bk_${now.microsecondsSinceEpoch}',
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      endStationId: '',
      status: 'active',
      paymentMethod: 'wallet',
      timeToPickup: now.add(const Duration(minutes: 15)),
      createdAt: now,
    );

    _bookings.add(dto);
    notifyListeners();
    return dto.toModel();
  }

  @override
  bool hasActiveBookingForUser(String userId) {
    return _bookings.any(
      (booking) => booking.userId == userId && _isActiveStatus(booking.status),
    );
  }

  @override
  bool hasActiveBookingForBike(String bikeId) {
    return _bookings.any(
      (booking) => booking.bikeId == bikeId && _isActiveStatus(booking.status),
    );
  }

  @override
  Future<void> completeBooking({
    required String bookingId,
    required String endStationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) {
      throw Exception('Booking not found');
    }

    final booking = _bookings[index];
    _bookings[index] = BookingDto(
      id: booking.id,
      userId: booking.userId,
      bikeId: booking.bikeId,
      startStationId: booking.startStationId,
      endStationId: endStationId,
      status: 'completed',
      paymentMethod: booking.paymentMethod,
      timeToPickup: booking.timeToPickup,
      createdAt: booking.createdAt,
    );
    notifyListeners();
  }
}
