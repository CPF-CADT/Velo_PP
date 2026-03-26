import 'package:latlong2/latlong.dart';

class Station {
  final String name;
  final LatLng location;
  final int bikes;
  final String address;

  Station({
    required this.name,
    required this.location,
    required this.bikes,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'bikes': bikes,
      'address': address,
    };
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      name: map['name'] ?? '',
      location: map['location'] ?? LatLng(0, 0),
      bikes: map['bikes'] ?? 0,
      address: map['address'] ?? '',
    );
  }
}
