import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/dock.dart';

class FirebaseDockRepository implements DockRepository {
  final FirebaseFirestore _firestore;
  final String _collectionPath = 'docks';

  final List<Dock> _docks = [];

  // Inject FirebaseFirestore.instance, or allow it to be passed for testing
  FirebaseDockRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> loadInitialData() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();

      _docks
        ..clear()
        ..addAll(
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id;
            return DockDto.fromMap(data).toModel();
          }),
        );
    } catch (e) {
      throw Exception('Failed to load initial dock data: $e');
    }
  }

  @override
  Future<List<Dock>> getDocksByStationId(String stationId) async {
    try {
      // Check cache first
      if (_docks.isNotEmpty) {
        return _docks
            .where((dock) => dock.stationId == stationId)
            .toList();
      }

      // If cache is empty, load all docks and filter locally to support
      // both camelCase and snake_case field variants in Firestore.
      final snapshot = await _firestore
          .collection(_collectionPath)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id;
            return DockDto.fromMap(data).toModel();
          })
          .where((dock) => dock.stationId == stationId)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch docks by station ID: $e');
    }
  }

  @override
  Future<void> updateDockStatus(String dockId, String status) async {
    try {
      await _firestore.collection(_collectionPath).doc(dockId).update({
        'status': status,
      });

      final index = _docks.indexWhere((dock) => dock.id == dockId);
      if (index != -1) {
        final current = _docks[index];
        _docks[index] = Dock(
          id: current.id,
          stationId: current.stationId,
          bikeId: current.bikeId,
          slotNumber: current.slotNumber,
          status: status,
        );
      }
    } catch (e) {
      throw Exception('Failed to update dock status: $e');
    }
  }

  @override
  Future<Dock?> getDockById(String dockId) async {
    try {
      if (_docks.isNotEmpty) {
        try {
          return _docks.firstWhere((dock) => dock.id == dockId);
        } catch (_) {
          return null;
        }
      }

      final doc = await _firestore.collection(_collectionPath).doc(dockId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Dock not found');
      }

      final data = doc.data()!;
      data['id'] = data['id'] ?? doc.id;

      final dto = DockDto.fromMap(data);
      return dto.toModel();
    } catch (e) {
      throw Exception('Failed to fetch dock by ID: $e');
    }
  }

  @override
  Future<void> checkoutBikeFromDock(String dockId) async {
    try {
      await _firestore.collection(_collectionPath).doc(dockId).update({
        'bikeId': '',
        'bike_id': '',
        'status': 'available',
      });

      final index = _docks.indexWhere((dock) => dock.id == dockId);
      if (index != -1) {
        final current = _docks[index];
        _docks[index] = Dock(
          id: current.id,
          stationId: current.stationId,
          bikeId: '',
          slotNumber: current.slotNumber,
          status: 'available',
        );
      }
    } catch (e) {
      throw Exception('Failed to checkout bike: $e');
    }
  }

  @override
  Future<void> assignBikeToDock({
    required String dockId,
    required String bikeId,
  }) async {
    try {
      await _firestore.collection(_collectionPath).doc(dockId).update({
        'bikeId': bikeId,
        'bike_id': bikeId,
        'status': 'occupied',
      });

      final index = _docks.indexWhere((dock) => dock.id == dockId);
      if (index != -1) {
        final current = _docks[index];
        _docks[index] = Dock(
          id: current.id,
          stationId: current.stationId,
          bikeId: bikeId,
          slotNumber: current.slotNumber,
          status: 'occupied',
        );
      }
    } catch (e) {
      throw Exception('Failed to assign bike to dock: $e');
    }
  }
}