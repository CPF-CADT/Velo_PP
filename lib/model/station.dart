import 'package:latlong2/latlong.dart';

class Station {
  final String id;
  final String name;
  final LatLng location;
  final int capacity;
  final int bikesAvailable;
  final String address;

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.bikesAvailable,
    required this.address,
  });

  int get bikes => bikesAvailable;

  Station copyWith({
    String? id,
    String? name,
    LatLng? location,
    int? capacity,
    int? bikesAvailable,
    String? address,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      bikesAvailable: bikesAvailable ?? this.bikesAvailable,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'capacity': capacity,
      'bikes_available': bikesAvailable,
      'address': address,
    };
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    final latitude = (map['latitude'] ?? map['lat'] ?? 0).toDouble();
    final longitude = (map['longitude'] ?? map['lng'] ?? 0).toDouble();
    final location = map['location'] is LatLng
        ? map['location'] as LatLng
        : LatLng(latitude, longitude);

    return Station(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      location: location,
      capacity: map['capacity'] ?? 0,
      bikesAvailable: map['bikes_available'] ?? map['bikesAvailable'] ?? 0,
      address: map['address'] ?? '',
    );
  }
}
