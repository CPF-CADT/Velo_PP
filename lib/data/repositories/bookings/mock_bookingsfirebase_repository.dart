import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/booking_dto.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/model/booking.dart';

class FirebaseBookingsRepository extends ChangeNotifier
    implements BookingsRepository {
  FirebaseBookingsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _bookingsCollection = 'bookings';

  final FirebaseFirestore _firestore;

  @override
  Future<List<Booking>> getBookingsForUser(String userId) async {
    final snapshot = await _firestore
        .collection(_bookingsCollection)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingDto.fromMap({...doc.data(), 'id': doc.id}).toModel())
        .toList();
  }

  Future<Booking?> getBookingById(String bookingId) async {
    final doc = await _firestore.collection(_bookingsCollection).doc(bookingId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return BookingDto.fromMap({...doc.data()!, 'id': doc.id}).toModel();
  }

  Future<void> createBooking({
    required String userId,
    required String bikeId,
    required String startStationId,
    required String endStationId,
    required DateTime timeToPickup,
    required String status,
    required String paymentMethod,
  }) async {
    await _firestore.collection(_bookingsCollection).add({
      'user_id': userId,
      'bike_id': bikeId,
      'start_station_id': startStationId,
      'end_station_id': endStationId,
      'time_to_pickup': timeToPickup.toIso8601String(),
      'status': status,
      'payment_method': paymentMethod,
      'created_at': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection(_bookingsCollection).doc(bookingId).update({
      'status': status,
    });
    notifyListeners();
  }

  Future<void> completeBooking(String bookingId) async {
    await _firestore.collection(_bookingsCollection).doc(bookingId).update({
      'status': 'completed',
    });
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    await _firestore.collection(_bookingsCollection).doc(bookingId).update({
      'status': 'cancelled',
    });
    notifyListeners();
  }
}
