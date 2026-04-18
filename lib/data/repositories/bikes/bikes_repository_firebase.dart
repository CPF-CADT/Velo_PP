import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_pp/data/dtos/bike_dto.dart';
import 'package:velo_pp/data/dtos/dock_dto.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/model/bike.dart';

class FirebaseBikesRepository implements BikesRepository {
	final FirebaseFirestore _firestore;
	final String _bikesCollectionPath = 'bikes';
	final String _docksCollectionPath = 'docks';

	final List<BikeDto> _bikes = [];
	final List<DockDto> _docks = [];

	FirebaseBikesRepository({FirebaseFirestore? firestore})
			: _firestore = firestore ?? FirebaseFirestore.instance;

	Future<void> loadInitialData() async {
		try {
			final snapshots = await Future.wait([
				_firestore.collection(_bikesCollectionPath).get(),
				_firestore.collection(_docksCollectionPath).get(),
			]);

			final bikesSnapshot = snapshots[0];
			final docksSnapshot = snapshots[1];

			_bikes
				..clear()
				..addAll(
					bikesSnapshot.docs.map((doc) {
						final data = doc.data();
						data['id'] = data['id'] ?? doc.id;
						return BikeDto.fromMap(data);
					}),
				);

			_docks
				..clear()
				..addAll(
					docksSnapshot.docs.map((doc) {
						final data = doc.data();
						data['id'] = data['id'] ?? doc.id;
						return DockDto.fromMap(data);
					}),
				);
		} catch (e) {
			throw Exception('Failed to load initial bike data: $e');
		}
	}

	@override
	Bike? getBikeById(String id) {
		final bike = _bikes.where((item) => item.id == id).toList();
		return bike.isEmpty ? null : bike.first.toModel();
	}

	@override
	List<Bike> getAvailableBikesForStation(String stationId) {
		final dockBikeIds = _docks
				.where((dock) => dock.stationId == stationId && dock.bikeId.isNotEmpty)
				.map((dock) => dock.bikeId)
				.toSet();

		return _bikes
				.where(
					(bike) => dockBikeIds.contains(bike.id) && bike.status == 'available',
				)
				.map((bike) => bike.toModel())
				.toList();
	}

	@override
	Future<void> updateBikeStatus(String bikeId, String status) async {
		try {
			await _firestore.collection(_bikesCollectionPath).doc(bikeId).update({
				'status': status,
			});

			final index = _bikes.indexWhere((bike) => bike.id == bikeId);
			if (index == -1) {
				throw Exception('Bike not found');
			}

			final bike = _bikes[index];
			_bikes[index] = BikeDto(id: bike.id, model: bike.model, status: status);
		} catch (e) {
			throw Exception('Failed to update bike status: $e');
		}
	}
}
