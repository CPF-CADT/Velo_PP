import 'package:latlong2/latlong.dart';

import '../../model/station.dart';

class StationDto {
  final String id;
  final String name;
  final LatLng location;
  final int capacity;
  final int bikesAvailable;
  final String address;

  StationDto({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.bikesAvailable,
    required this.address,
  });

  Station toModel() {
    return Station(
      id: id,
      name: name,
      location: location,
      capacity: capacity,
      bikesAvailable: bikesAvailable,
      address: address,
    );
  }

  factory StationDto.fromModel(Station station) {
    return StationDto(
      id: station.id,
      name: station.name,
      location: station.location,
      capacity: station.capacity,
      bikesAvailable: station.bikesAvailable,
      address: station.address,
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

  factory StationDto.fromMap(Map<String, dynamic> map) {
    final nestedLocation = map['location'];
    final latitude =
        (map['latitude'] ??
                map['lat'] ??
                (nestedLocation is Map ? nestedLocation['lat'] : null) ??
                0)
            .toDouble();
    final longitude =
        (map['longitude'] ??
                map['lng'] ??
                (nestedLocation is Map ? nestedLocation['lng'] : null) ??
                0)
            .toDouble();
    final location = map['location'] is LatLng
        ? map['location'] as LatLng
        : LatLng(latitude, longitude);

    return StationDto(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      location: location,
      capacity: map['capacity'] ?? 0,
      bikesAvailable: map['bikes_available'] ?? map['bikesAvailable'] ?? 0,
      address: map['address'] ?? '',
    );
  }
}
