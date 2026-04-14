import 'package:flutter/foundation.dart';
import 'package:velo_pp/model/user.dart';

abstract class AuthRepository extends ChangeNotifier {
  User get currentUser;
}
