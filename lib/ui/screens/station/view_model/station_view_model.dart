import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/booking.dart';
import 'package:velo_pp/model/dock.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class StationViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BikesRepository _bikesRepository;
  final BookingsRepository _bookingsRepository;
  final DockRepository _dockRepository;
  final PassesRepository _passesRepository;
  final RideState _rideState;

  AsyncValue<List<Dock>> slots = AsyncValue.loading();
  String? _currentStationId;
  String? _selectedDockId;
  bool _isBooking = false;

  StationViewModel({
    required AuthRepository authRepository,
    required BikesRepository bikesRepository,
    required BookingsRepository bookingsRepository,
    required DockRepository dockRepository,
    required PassesRepository passesRepository,
     required RideState rideState,
  }) : _authRepository = authRepository,
       _bikesRepository = bikesRepository,
       _bookingsRepository = bookingsRepository,
       _dockRepository = dockRepository,
       _passesRepository = passesRepository,
       _rideState = rideState;

  String? get selectedDockId => _selectedDockId;
  bool get isBooking => _isBooking;
  bool get hasActiveRide {
    return _bookingsRepository.hasActiveBookingForUser(
      _authRepository.currentUser.id,
    );
  }

  bool get hasActivePass {
    final pass = _passesRepository.getActivePassForUser(
      _authRepository.currentUser.id,
    );
    return pass?.isActiveNow ?? false;
  }

  String getBikeModel(String bikeId) {
    if (bikeId.isEmpty) {
      return '-';
    }

    final bike = _bikesRepository.getBikeById(bikeId);
    return bike?.model ?? bikeId;
  }

  Dock? get selectedDock {
    final data = slots.data;
    if (data == null || _selectedDockId == null) {
      return null;
    }

    for (final dock in data) {
      if (dock.id == _selectedDockId) {
        return dock;
      }
    }

    return null;
  }

  Future<void> loadSlots(String stationId) async {
    _currentStationId = stationId;
    slots = AsyncValue.loading();
    notifyListeners();

    try {
      final data = await _dockRepository.getDocksByStationId(stationId);
      slots = AsyncValue.success(data);
      if (_selectedDockId != null &&
          !data.any((dock) => dock.id == _selectedDockId)) {
        _selectedDockId = null;
      }
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

  void selectDock(String dockId) {
    if (hasActiveRide) {
      return;
    }

    if (slots.state != AsyncValueState.success || slots.data == null) {
      return;
    }

    final dock = slots.data!.where((item) => item.id == dockId).firstOrNull;
    if (dock == null || dock.status != 'occupied' || dock.bikeId.isEmpty) {
      return;
    }

    _selectedDockId = dock.id;
    notifyListeners();
  }

  Future<Booking> bookSelectedBike({String? purchasePassId}) async {
    final stationId = _currentStationId;
    final dock = selectedDock;
    final isSingleTicket = purchasePassId == 'single_pass';

    if (stationId == null) {
      throw Exception('Station is not loaded');
    }
    if (dock == null || dock.bikeId.isEmpty) {
      throw Exception('Please select a bike first');
    }
    if (_isBooking) {
      throw Exception('Booking in progress');
    }
    if (hasActiveRide) {
      throw Exception('You already have an active ride. Return it first.');
    }

    final userId = _authRepository.currentUser.id;
    if (!hasActivePass && !isSingleTicket) {
      if (purchasePassId == null) {
        throw const PassRequiredException();
      }
      await _passesRepository.purchasePass(userId, purchasePassId);
    }

    _isBooking = true;
    notifyListeners();

    try {
      final booking = await _bookingsRepository.createBooking(
        userId: userId,
        bikeId: dock.bikeId,
        startStationId: stationId,
      );

      await _bikesRepository.updateBikeStatus(dock.bikeId, 'in_use');
      await _dockRepository.checkoutBikeFromDock(dock.id);

      _selectedDockId = null;
      await loadSlots(stationId);
      _rideState.notifyRideBooked(booking);
      return booking;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }
}

class PassRequiredException implements Exception {
  const PassRequiredException();

  @override
  String toString() {
    return 'You need a pass before booking.';
  }
}
