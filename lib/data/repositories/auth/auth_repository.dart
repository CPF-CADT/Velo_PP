import 'package:velo_pp/model/user.dart';

abstract class AuthRepository {
  User get currentUser;
}
