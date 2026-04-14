import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/user_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/model/user.dart';

class MockAuthRepository extends ChangeNotifier implements AuthRepository {
  final List<UserDto> _users = List<UserDto>.from(MockData.users);

  @override
  User get currentUser => _users.first.toModel();
}
