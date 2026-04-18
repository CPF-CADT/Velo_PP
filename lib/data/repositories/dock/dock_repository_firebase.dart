 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/repositories/dock/dock_repository.dart';
import 'package:velo_pp/model/dock.dart';

class FirebaseDockRepository extends ChangeNotifier implements DockRepository {
  final FirebaseFirestore _firestore;
  final String _collectionPath = 'docks';

  // Inject FirebaseFirestore.instance, or allow it to be passed for testing
  FirebaseDockRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Dock>> getDocksByStationId(String stationId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('station_id', isEqualTo: stationId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Fallback to document ID if 'id' field is missing in Firestore
        data['id'] = data['id'] ?? doc.id; 
        
        final dto = DockDto.fromMap(data);
        return dto.toModel();
      }).toList();
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
      notifyListeners(); // Matches mock behavior
    } catch (e) {
      throw Exception('Failed to update dock status: $e');
    }
  }

  @override
  Future<Dock?> getDockById(String dockId) async {
    try {
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
        'bike_id': '',
        'status': 'available',
      });
      notifyListeners(); // Matches mock behavior
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
        'bike_id': bikeId,
        'status': 'occupied',
      });
      notifyListeners(); // Matches mock behavior
    } catch (e) {
      throw Exception('Failed to assign bike to dock: $e');
    }
  }
}