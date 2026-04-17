import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class StationViewModel extends ChangeNotifier {
  final DockRepository _dockRepository;

  AsyncValue<List<Dock>> slots = AsyncValue.loading();
  String? _currentStationId;

  StationViewModel({required DockRepository dockRepository})
      : _dockRepository = dockRepository;

  Future<void> loadSlots(String stationId) async {
    _currentStationId = stationId;
    slots = AsyncValue.loading();
    notifyListeners();

    try {
      final data = await _dockRepository.getDocksByStationId(stationId);
      slots = AsyncValue.success(data);
    } catch (e) {
      slots = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> updateSlotStatus(String dockId, String status) async {
    try {
      await _dockRepository.updateDockStatus(dockId, status);
      if (_currentStationId != null) {
        await loadSlots(_currentStationId!);
      }
    } catch (e) {
      slots = AsyncValue.error(e);
      notifyListeners();
    }
  }

  void removeDockFromList(String dockId) {
    if (slots.state == AsyncValueState.success && slots.data != null) {
      final updatedSlots = slots.data!.where((dock) => dock.id != dockId).toList();
      slots = AsyncValue.success(updatedSlots);
      notifyListeners();
    }
  }
}
