import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user.dart';
import 'package:velo_pp/model/user_pass.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class PassesData {
  final User user;
  final List<Pass> passes;
  final UserPass? activePass;

  const PassesData({
    required this.user,
    required this.passes,
    required this.activePass,
  });
}

class PassesViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final PassesRepository _passesRepository;

  AsyncValue<PassesData> passes = AsyncValue.loading();

  PassesViewModel({
    required AuthRepository authRepository,
    required PassesRepository passesRepository,
  }) : _authRepository = authRepository,
       _passesRepository = passesRepository;

  Future<void> loadPasses() async {
    passes = AsyncValue.loading();
    notifyListeners();

    try {
      final user = _authRepository.currentUser;
      final items = _passesRepository.getPasses();
      final active = _passesRepository.getActivePassForUser(user.id);
      passes = AsyncValue.success(
        PassesData(user: user, passes: items, activePass: active),
      );
    } catch (e) {
      passes = AsyncValue.error(e);
    }

    notifyListeners();
  }
}
