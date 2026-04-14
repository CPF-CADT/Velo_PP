import 'package:flutter/widgets.dart';
import 'package:velo_pp/core/constants/app_constants.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/model/user.dart';
import 'package:velo_pp/ui/states/app_settings_state.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AppSettingsState _settings;

  ProfileViewModel({
    required AuthRepository authRepository,
    required AppSettingsState settings,
  }) : _authRepository = authRepository,
       _settings = settings {
    _authRepository.addListener(_onDataChanged);
    _settings.addListener(_onDataChanged);
  }

  User get user => _authRepository.currentUser;

  Locale get locale => _settings.locale ?? AppConstants.defaultLocale;

  String get initials => _getInitials(user.displayName);

  void _onDataChanged() {
    notifyListeners();
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'U';
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    final initials = (first + last).toUpperCase();

    return initials.isEmpty ? 'U' : initials;
  }

  @override
  void dispose() {
    _authRepository.removeListener(_onDataChanged);
    _settings.removeListener(_onDataChanged);
    super.dispose();
  }
}
