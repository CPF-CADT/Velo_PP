import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/bike_dto.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/model/bike.dart';

class MockBikesRepository extends ChangeNotifier implements BikesRepository {
  final List<BikeDto> _bikes = List<BikeDto>.from(MockData.bikes);
  final List<DockDto> _docks = List<DockDto>.from(MockData.docks);

  @override
  Bike? getBikeById(String id) {
    final bike = _bikes.where((item) => item.id == id).toList();
    return bike.isEmpty ? null : bike.first.toModel();
  }

  @override
  List<Bike> getAvailableBikesForStation(String stationId) {
    final dockBikeIds = _docks
        .where((dock) => dock.stationId == stationId && dock.bikeId.isNotEmpty)
        .map((dock) => dock.bikeId)
        .toSet();

    return _bikes
        .where(
          (bike) => dockBikeIds.contains(bike.id) && bike.status == 'available',
        )
        .map((bike) => bike.toModel())
        .toList();
  }
}
