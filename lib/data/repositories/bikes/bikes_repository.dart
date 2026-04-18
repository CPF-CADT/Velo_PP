import 'package:velo_pp/model/bike.dart';

abstract class BikesRepository {
  Bike? getBikeById(String id);
  List<Bike> getAvailableBikesForStation(String stationId);
  Future<void> updateBikeStatus(String bikeId, String status);
}
