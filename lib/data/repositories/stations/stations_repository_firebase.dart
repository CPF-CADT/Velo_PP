import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/bike_dto.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/dtos/station_dto.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/model/bike.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/model/station.dart';

class FirebaseStationsRepository extends ChangeNotifier
    implements StationsRepository {
  final FirebaseFirestore _firestore;
  final String _stationsCollection = 'stations';
  final String _bikesCollection = 'bikes';
  final String _docksCollection = 'docks';

  final List<Station> _stations = [];
  final List<Bike> _bikes = [];
  final List<Dock> _docks = [];

  FirebaseStationsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> loadInitialData() async {
    try {
      final snapshots = await Future.wait([
        _firestore.collection(_stationsCollection).get(),
        _firestore.collection(_bikesCollection).get(),
        _firestore.collection(_docksCollection).get(),
      ]);

      final stationsSnapshot = snapshots[0];
      final bikesSnapshot = snapshots[1];
      final docksSnapshot = snapshots[2];

      _stations
        ..clear()
        ..addAll(
          stationsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id;
            return StationDto.fromMap(data).toModel();
          }),
        );

      _bikes
        ..clear()
        ..addAll(
          bikesSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id;
            return BikeDto.fromMap(data).toModel();
          }),
        );

      _docks
        ..clear()
        ..addAll(
          docksSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id;
            return DockDto.fromMap(data).toModel();
          }),
        );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load initial station data: $e');
    }
  }

  @override
  List<Station> getStations() {
    return _stations
        .map(
          (station) => station.copyWith(
            bikesAvailable: _getAvailableBikesCount(station.id),
          ),
        )
        .toList();
  }

  @override
  Station? getStationById(String id) {
    final station = _stations.where((item) => item.id == id).toList();
    if (station.isEmpty) {
      return null;
    }

    return station.first.copyWith(
      bikesAvailable: _getAvailableBikesCount(id),
    );
  }

  int _getAvailableBikesCount(String stationId) {
    final dockBikeIds = _docks
        .where((dock) => dock.stationId == stationId && dock.bikeId.isNotEmpty)
        .map((dock) => dock.bikeId)
        .toSet();

    return _bikes
        .where(
          (bike) => dockBikeIds.contains(bike.id) && bike.status == 'available',
        )
        .length;
  }
}
