class Pass {
  final String id;
  final String name;
  final double price;
  final int durationHours;
  final List<String> features;

  const Pass({
    required this.id,
    required this.name,
    required this.price,
    required this.durationHours,
    required this.features,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration_hours': durationHours,
      'features': features,
    };
  }

  factory Pass.fromMap(Map<String, dynamic> map) {
    return Pass(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationHours: map['duration_hours'] ?? map['durationHours'] ?? 0,
      features: List<String>.from(map['features'] ?? []),
    );
  }
}
