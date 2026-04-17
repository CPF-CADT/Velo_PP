import '../../model/pass.dart';

class PassDto {
  final String id;
  final String name;
  final double price;
  final int durationHours;
  final List<String> features;

  const PassDto({
    required this.id,
    required this.name,
    required this.price,
    required this.durationHours,
    required this.features,
  });

  Pass toModel() {
    return Pass(id: id, name: name, price: price, durationHours: durationHours, features: features);
  }

  factory PassDto.fromModel(Pass pass) {
    return PassDto(
      id: pass.id,
      name: pass.name,
      price: pass.price,
      durationHours: pass.durationHours,
      features: pass.features,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration_hours': durationHours,
      'features': features,
    };
  }

  factory PassDto.fromMap(Map<String, dynamic> map) {
    return PassDto(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationHours: map['duration_hours'] ?? map['durationHours'] ?? 0,
      features: List<String>.from(map['features'] ?? []),
    );
  }
}
