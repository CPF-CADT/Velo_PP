import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/bike.dart';

abstract class BikesRepository extends ChangeNotifier {
  Bike? getBikeById(String id);
  List<Bike> getAvailableBikesForStation(String stationId);
}
