import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/booking_dto.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/model/booking.dart';

class FirebaseBookingsRepository extends ChangeNotifier
		implements BookingsRepository {
	final FirebaseFirestore _firestore;
	final String _collectionPath = 'bookings';

	final List<Booking> _bookings = [];

	FirebaseBookingsRepository({FirebaseFirestore? firestore})
			: _firestore = firestore ?? FirebaseFirestore.instance;

	Future<void> loadInitialData() async {
		try {
			final snapshot = await _firestore.collection(_collectionPath).get();

			_bookings
				..clear()
				..addAll(snapshot.docs.map(_bookingFromDoc));

			notifyListeners();
		} catch (e) {
			throw Exception('Failed to load initial booking data: $e');
		}
	}

	bool _isActiveStatus(String status) {
		return status.trim().toLowerCase() == 'active';
	}

	Booking _bookingFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
		final data = doc.data() ?? <String, dynamic>{};
		final timeToPickup = data['time_to_pickup'] ?? data['timeToPickup'];
		final createdAt = data['created_at'] ?? data['createdAt'];

		String toIsoString(dynamic value) {
			if (value is Timestamp) {
				return value.toDate().toIso8601String();
			}
			if (value is DateTime) {
				return value.toIso8601String();
			}
			if (value is String) {
				return value;
			}
			return '';
		}

		return BookingDto.fromMap({
			...data,
			'id': doc.id,
			'time_to_pickup': toIsoString(timeToPickup),
			'created_at': toIsoString(createdAt),
		}).toModel();
	}

	@override
	List<Booking> getBookingsForUser(String userId) {
		final list = _bookings.where((booking) => booking.userId == userId).toList();
		list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
		return list;
	}

	@override
	Future<Booking> createBooking({
		required String userId,
		required String bikeId,
		required String startStationId,
	}) async {
		try {
			if (hasActiveBookingForUser(userId)) {
				throw Exception('You already have an active booking');
			}

			if (hasActiveBookingForBike(bikeId)) {
				throw Exception('This bike is already booked');
			}

			final now = DateTime.now();
			final docRef = _firestore.collection(_collectionPath).doc();

			await docRef.set({
				'userId': userId,
				'user_id': userId,
				'bikeId': bikeId,
				'bike_id': bikeId,
				'startStationId': startStationId,
				'start_station_id': startStationId,
				'endStationId': '',
				'end_station_id': '',
				'status': 'active',
				'paymentMethod': 'wallet',
				'payment_method': 'wallet',
				'timeToPickup': Timestamp.fromDate(now.add(const Duration(minutes: 15))),
				'time_to_pickup': Timestamp.fromDate(now.add(const Duration(minutes: 15))),
				'createdAt': Timestamp.fromDate(now),
				'created_at': Timestamp.fromDate(now),
			});

			final createdDoc = await docRef.get();
			final createdBooking = _bookingFromDoc(createdDoc);

			_bookings.add(createdBooking);
			notifyListeners();

			return createdBooking;
		} catch (e) {
			throw Exception('Failed to create booking: $e');
		}
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
		try {
			final docRef = _firestore.collection(_collectionPath).doc(bookingId);
			final doc = await docRef.get();

			if (!doc.exists || doc.data() == null) {
				throw Exception('Booking not found');
			}

			await docRef.update({
				'endStationId': endStationId,
				'end_station_id': endStationId,
				'status': 'completed',
			});

			final index = _bookings.indexWhere((booking) => booking.id == bookingId);
			if (index != -1) {
				final current = _bookings[index];
				_bookings[index] = Booking(
					id: current.id,
					userId: current.userId,
					bikeId: current.bikeId,
					startStationId: current.startStationId,
					endStationId: endStationId,
					status: 'completed',
					paymentMethod: current.paymentMethod,
					timeToPickup: current.timeToPickup,
					createdAt: current.createdAt,
				);
			}

			notifyListeners();
		} catch (e) {
			throw Exception('Failed to complete booking: $e');
		}
	}
}
