import '../../model/booking.dart';

class BookingDto {
  final String id;
  final String userId;
  final String bikeId;
  final String startStationId;
  final String endStationId;
  final String status;
  final String paymentMethod;
  final DateTime timeToPickup;
  final DateTime createdAt;

  const BookingDto({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.startStationId,
    required this.endStationId,
    required this.status,
    required this.paymentMethod,
    required this.timeToPickup,
    required this.createdAt,
  });

  Booking toModel() {
    return Booking(
      id: id,
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      endStationId: endStationId,
      status: status,
      paymentMethod: paymentMethod,
      timeToPickup: timeToPickup,
      createdAt: createdAt,
    );
  }

  factory BookingDto.fromModel(Booking booking) {
    return BookingDto(
      id: booking.id,
      userId: booking.userId,
      bikeId: booking.bikeId,
      startStationId: booking.startStationId,
      endStationId: booking.endStationId,
      status: booking.status,
      paymentMethod: booking.paymentMethod,
      timeToPickup: booking.timeToPickup,
      createdAt: booking.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'bike_id': bikeId,
      'start_station_id': startStationId,
      'end_station_id': endStationId,
      'status': status,
      'payment_method': paymentMethod,
      'time_to_pickup': timeToPickup.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BookingDto.fromMap(Map<String, dynamic> map) {
    return BookingDto(
      id: map['id']?.toString() ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      bikeId: map['bike_id'] ?? map['bikeId'] ?? '',
      startStationId: map['start_station_id'] ?? map['startStationId'] ?? '',
      endStationId: map['end_station_id'] ?? map['endStationId'] ?? '',
      status: map['status'] ?? '',
      paymentMethod: map['payment_method'] ?? map['paymentMethod'] ?? '',
      timeToPickup:
          DateTime.tryParse(map['time_to_pickup'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
