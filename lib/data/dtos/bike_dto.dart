import '../../model/bike.dart';

class BikeDto {
  final String id;
  final String model;
  final String status;

  const BikeDto({required this.id, required this.model, required this.status});

  Bike toModel() {
    return Bike(id: id, model: model, status: status);
  }

  factory BikeDto.fromModel(Bike bike) {
    return BikeDto(id: bike.id, model: bike.model, status: bike.status);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'model': model, 'status': status};
  }

  factory BikeDto.fromMap(Map<String, dynamic> map) {
    return BikeDto(
      id: map['id']?.toString() ?? '',
      model: map['model'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
