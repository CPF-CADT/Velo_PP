import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/station.dart';

abstract class StationsRepository extends ChangeNotifier {
  List<Station> getStations();
  Station? getStationById(String id);
}
