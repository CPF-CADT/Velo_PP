import 'package:velo_pp/model/dock.dart';

abstract class DockRepository {
  Future<List<Dock>> getDocksByStationId(String stationId);
  Future<void> updateDockStatus(String dockId, String status);
  Future<Dock?> getDockById(String dockId);
  Future<void> checkoutBikeFromDock(String dockId);
  Future<void> assignBikeToDock({
    required String dockId,
    required String bikeId,
  });
}
