import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_pp/data/dtos/pass_dto.dart';
import 'package:velo_pp/data/dtos/user_pass_dto.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user_pass.dart';

class FirebasePassesRepository
    implements PassesRepository {
  FirebasePassesRepository();

  static const String _passesCollection = 'passes';
  static const String _userPassesCollection = 'user_passes';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // 

  final List<Pass> _passes = [];  // user for cach
  final List<UserPass> _userPasses = [];  // use for cash data in local memory



  
  @override
  List<Pass> getPasses() => _passes;

  @override
  Pass? getPassById(String id) {
    try {
      return _passes.firstWhere((pass) => pass.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  UserPass? getActivePassForUser(String userId) {
    try {
      return _userPasses.firstWhere(
        (userPass) => userPass.userId == userId && userPass.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  List<UserPass> getAllUserPasses(String userId) {
    return _userPasses.where((userPass) => userPass.userId == userId).toList();
  }
  // initaldata both passes and user passs
  Future<void> loadInitialData() async {
    await Future.wait([
      _loadPasses(),
      _loadUserPasses(),
    ]);
  }
  // load pass from firebase save in local meomory _passses
  Future<void> _loadPasses() async {
    final snapshot = await _firestore.collection(_passesCollection).get();

    _passes
      ..clear()
      ..addAll(
        snapshot.docs.map(
          (doc) =>
              PassDto.fromMap({...doc.data(), 'id': doc.id}).toModel(),
        ),
      );
  }
  // load user pass from firebase save in local meomory _user passses
  Future<void> _loadUserPasses() async {
    final snapshot = await _firestore.collection(_userPassesCollection).get();

    final loaded = <UserPass>[
      ...snapshot.docs.map(_userPassFromDoc),
    ];

    _userPasses
      ..clear()
      ..addAll(loaded);  // trasform the doc userpass to user pass model by using _userPassFromDoc
  }
  // user to convert pass from firebase format to model by using document snapshot
  UserPass _userPassFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};  // get data from doc
    final startDate =
        data['start_date'] ?? data['purchaseDate'] ?? data['startDate'];
    final endDate =
        data['end_date'] ?? data['expirationDate'] ?? data['endDate'];

    String toIsoString(dynamic value) {
      if (value is Timestamp) {
        return value.toDate().toIso8601String();
      }
      if (value is DateTime) {
        return value.toIso8601String();
      }
      if (value is String) {
        return value;
      }
      return '';
    }

    return UserPassDto.fromMap({
      ...data,
      'id': doc.id,  // unique id doc for keeping update later
      'start_date': toIsoString(startDate),
      'end_date': toIsoString(endDate),
      'is_active': data['is_active'] ?? data['isActive'] ?? false,
    }).toModel();
  }

  @override
  Future<UserPass> purchasePass(String userId, String passId) async {
    Pass? pass = getPassById(passId);
    // not in caches query to database
    if (pass == null) {
      final passDoc = await _firestore.collection(_passesCollection).doc(passId).get();
      if (passDoc.exists && passDoc.data() != null) {  // check doc exist and have data or not
        pass = PassDto.fromMap({...passDoc.data()!, 'id': passDoc.id}).toModel();
      }
    }

    if (pass == null) {
      throw Exception('Pass not found');
    }

    final now = DateTime.now();
    // create reference for user pass from db
    final userPassRef = _firestore.collection(_userPassesCollection).doc();

    // get only active pass 
    final activeSnapshot = await _firestore
        .collection(_userPassesCollection)
        .where('user_id', isEqualTo: userId)
        .where('is_active', isEqualTo: true)
        .get();

    final activeDocs = <DocumentSnapshot<Map<String, dynamic>>>[
      ...activeSnapshot.docs,
    ];
      // use runtracsaction for secure operation in this block success together
    await _firestore.runTransaction((tx) async {
      DateTime newEndDate = now.add(Duration(hours: pass!.durationHours));

      for (final oldDoc in activeDocs) {
        final oldPass = oldDoc.data() ?? <String, dynamic>{};
        final oldEndRaw =
            oldPass['end_date'] ?? oldPass['expirationDate'] ?? oldPass['endDate'];
        DateTime? oldEndDate;
        if (oldEndRaw is Timestamp) {
          oldEndDate = oldEndRaw.toDate();
        } else if (oldEndRaw is String) {
          oldEndDate = DateTime.tryParse(oldEndRaw);
        } else if (oldEndRaw is DateTime) {
          oldEndDate = oldEndRaw;
        }

        // only add duration if duration=true AND old pass is still valid
        if (oldEndDate != null && oldEndDate.isAfter(now)) {
          newEndDate = oldEndDate.add(Duration(hours: pass.durationHours));
        }

        // always deactivate old pass
        tx.update(oldDoc.reference, {'is_active': false, 'isActive': false});
      }
        // create userpass
      tx.set(userPassRef, {
        'user_id': userId,
        'pass_id': passId,
        'start_date': Timestamp.fromDate(now),
        'end_date': Timestamp.fromDate(newEndDate),
        'is_active': true,
      });
    });
    // get and create usepass convert to model 
    final created = await userPassRef.get();
    final createdModel = _userPassFromDoc(created);
    
    await _loadUserPasses();

    return createdModel;
  }
}


