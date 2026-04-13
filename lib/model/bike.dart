class Bike {
  final String id;
  final String model;
  final String status;

  const Bike({required this.id, required this.model, required this.status});

  Map<String, dynamic> toMap() {
    return {'id': id, 'model': model, 'status': status};
  }

  factory Bike.fromMap(Map<String, dynamic> map) {
    return Bike(
      id: map['id']?.toString() ?? '',
      model: map['model'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
