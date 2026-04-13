class Dock {
  final String id;
  final String stationId;
  final String bikeId;
  final String slotNumber;
  final String status;

  const Dock({
    required this.id,
    required this.stationId,
    required this.bikeId,
    required this.slotNumber,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'station_id': stationId,
      'bike_id': bikeId,
      'slot_number': slotNumber,
      'status': status,
    };
  }

  factory Dock.fromMap(Map<String, dynamic> map) {
    return Dock(
      id: map['id']?.toString() ?? '',
      stationId: map['station_id'] ?? map['stationId'] ?? '',
      bikeId: map['bike_id'] ?? map['bikeId'] ?? '',
      slotNumber: map['slot_number'] ?? map['slotNumber'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
