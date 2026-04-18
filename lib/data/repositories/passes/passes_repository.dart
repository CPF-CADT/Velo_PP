import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user_pass.dart';

abstract class PassesRepository {
  List<Pass> getPasses();
  Pass? getPassById(String id);
  UserPass? getActivePassForUser(String userId);

  List<UserPass> getAllUserPasses(String userId);

  Future<UserPass> purchasePass(String userId, String passId);
 
}
