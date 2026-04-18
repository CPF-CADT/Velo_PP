import 'package:velo_pp/data/dtos/bike_dto.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/dtos/station_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/model/station.dart';

class MockStationsRepository implements StationsRepository {
  final List<StationDto> _stations = List<StationDto>.from(MockData.stations);
  final List<BikeDto> _bikes = List<BikeDto>.from(MockData.bikes);
  final List<DockDto> _docks = List<DockDto>.from(MockData.docks);

  @override
  List<Station> getStations() {
    return _stations
        .map(
          (station) => station.toModel().copyWith(
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

    return station.first.toModel().copyWith(
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
