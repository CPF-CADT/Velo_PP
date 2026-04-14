import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final StationsRepository _stationsRepository;

  AsyncValue<List<Station>> stations = AsyncValue.loading();

  MapViewModel({required StationsRepository stationsRepository})
    : _stationsRepository = stationsRepository;

  Future<void> loadStations() async {
    stations = AsyncValue.loading();
    notifyListeners();

    try {
      final data = _stationsRepository.getStations();
      stations = AsyncValue.success(data);
    } catch (e) {
      stations = AsyncValue.error(e);
    }

    notifyListeners();
  }
}
