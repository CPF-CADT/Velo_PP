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

  bool _isActiveStatus(String status) {
    return status.trim().toLowerCase() == 'active';
  }

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

  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    if (await hasActiveBookingForUser(userId)) {
      throw Exception('You already have an active booking');
    }

    if (await hasActiveBookingForBike(bikeId)) {
      throw Exception('This bike is already booked');
    }

    final now = DateTime.now();
    final docRef = await _firestore.collection(_bookingsCollection).add({
      'user_id': userId,
      'bike_id': bikeId,
      'start_station_id': startStationId,
      'end_station_id': '',
      'status': 'active',
      'payment_method': 'wallet',
      'time_to_pickup': now.add(const Duration(minutes: 15)).toIso8601String(),
      'created_at': now.toIso8601String(),
    });

    final booking = Booking(
      id: docRef.id,
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      endStationId: '',
      status: 'active',
      paymentMethod: 'wallet',
      timeToPickup: now.add(const Duration(minutes: 15)),
      createdAt: now,
    );

    notifyListeners();
    return booking;
  }

  @override
  Future<bool> hasActiveBookingForUser(String userId) async {
    final snapshot = await _firestore
        .collection(_bookingsCollection)
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<bool> hasActiveBookingForBike(String bikeId) async {
    final snapshot = await _firestore
        .collection(_bookingsCollection)
        .where('bike_id', isEqualTo: bikeId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> completeBooking({
    required String bookingId,
    required String endStationId,
  }) async {
    await _firestore.collection(_bookingsCollection).doc(bookingId).update({
      'status': 'completed',
      'end_station_id': endStationId,
    });
    notifyListeners();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection(_bookingsCollection).doc(bookingId).update({
      'status': status,
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
