import '../../model/dock.dart';

class DockDto {
  final String id;
  final String stationId;
  final String bikeId;
  final String slotNumber;
  final String status;

  const DockDto({
    required this.id,
    required this.stationId,
    required this.bikeId,
    required this.slotNumber,
    required this.status,
  });

  Dock toModel() {
    return Dock(
      id: id,
      stationId: stationId,
      bikeId: bikeId,
      slotNumber: slotNumber,
      status: status,
    );
  }

  factory DockDto.fromModel(Dock dock) {
    return DockDto(
      id: dock.id,
      stationId: dock.stationId,
      bikeId: dock.bikeId,
      slotNumber: dock.slotNumber,
      status: dock.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'station_id': stationId,
      'bike_id': bikeId,
      'slot_number': slotNumber,
      'status': status,
    };
  }

  factory DockDto.fromMap(Map<String, dynamic> map) {
    return DockDto(
      id: map['id']?.toString() ?? '',
      stationId: map['station_id'] ?? map['stationId'] ?? '',
      bikeId: map['bike_id'] ?? map['bikeId'] ?? '',
      slotNumber: map['slot_number'] ?? map['slotNumber'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
