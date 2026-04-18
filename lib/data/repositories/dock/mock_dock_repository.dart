import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/dock.dart';

class MockDockRepository implements DockRepository {
  final List<DockDto> _docks = List<DockDto>.from(MockData.docks);

  @override
  Future<List<Dock>> getDocksByStationId(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _docks
        .where((dock) => dock.stationId == stationId)
        .map((dock) => dock.toModel())
        .toList();
  }

  @override
  Future<void> updateDockStatus(String dockId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _docks.indexWhere((dock) => dock.id == dockId);
    if (index != -1) {
      final dock = _docks[index];
      _docks[index] = DockDto(
        id: dock.id,
        stationId: dock.stationId,
        bikeId: dock.bikeId,
        slotNumber: dock.slotNumber,
        status: status,
      );
    }
  }

  @override
  Future<Dock?> getDockById(String dockId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final dock = _docks.firstWhere(
      (dock) => dock.id == dockId,
      orElse: () => throw Exception('Dock not found'),
    );
    return dock.toModel();
  }

  @override
  Future<void> checkoutBikeFromDock(String dockId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _docks.indexWhere((dock) => dock.id == dockId);
    if (index == -1) {
      throw Exception('Dock not found');
    }

    final dock = _docks[index];
    _docks[index] = DockDto(
      id: dock.id,
      stationId: dock.stationId,
      bikeId: '',
      slotNumber: dock.slotNumber,
      status: 'available',
    );
  }

  @override
  Future<void> assignBikeToDock({
    required String dockId,
    required String bikeId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _docks.indexWhere((dock) => dock.id == dockId);
    if (index == -1) {
      throw Exception('Dock not found');
    }

    final dock = _docks[index];
    _docks[index] = DockDto(
      id: dock.id,
      stationId: dock.stationId,
      bikeId: bikeId,
      slotNumber: dock.slotNumber,
      status: 'occupied',
    );
  }
}
