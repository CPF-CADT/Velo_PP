import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/pass_dto.dart';
import 'package:velo_pp/data/dtos/user_pass_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user_pass.dart';

class MockPassesRepository extends ChangeNotifier implements PassesRepository {
  final List<PassDto> _passes = List<PassDto>.from(MockData.passes);
  final List<UserPassDto> _userPasses = List<UserPassDto>.from(
    MockData.userPasses,
  );

  @override
  List<Pass> getPasses() => _passes.map((pass) => pass.toModel()).toList();

  @override
  Pass? getPassById(String id) {
    final pass = _passes.where((item) => item.id == id).toList();
    return pass.isEmpty ? null : pass.first.toModel();
  }

  @override
  UserPass? getActivePassForUser(String userId) {
    final active = _userPasses
        .where((item) => item.userId == userId && item.isActive)
        .toList();
    return active.isEmpty ? null : active.first.toModel();
  }
}
