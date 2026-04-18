import 'package:velo_pp/model/station.dart';

abstract class StationsRepository {
  List<Station> getStations();
  Station? getStationById(String id);
}
