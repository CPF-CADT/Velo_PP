import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/core/constants/app_constants.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/states/app_settings_state.dart';
import 'package:velo_pp/ui/screens/profile/view_model/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const ProfileScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        authRepository: context.read<AuthRepository>(),
        settings: context.read<AppSettingsState>(),
      ),
      child: _ProfileView(onLocaleChange: onLocaleChange),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const _ProfileView({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text(loc.get('profile'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, loc, viewModel),
            const SizedBox(height: 16),
            Text(
              loc.get('userSettings'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLanguageCard(context, loc, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    AppLocalizations loc,
    ProfileViewModel viewModel,
  ) {
    final user = viewModel.user;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.teal,
            child: Text(
              viewModel.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.displayName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(loc.get('email'), user.email),
          const SizedBox(height: 8),
          _buildInfoRow(loc.get('phone'), user.phone),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    AppLocalizations loc,
    ProfileViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              loc.get('language'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 110, maxWidth: 150),
            child: DropdownButton<Locale>(
              value: viewModel.locale,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: AppConstants.supportedLocales.map((supported) {
                final label = supported.languageCode == 'km'
                    ? loc.get('khmer')
                    : loc.get('english');

                return DropdownMenuItem(value: supported, child: Text(label));
              }).toList(),
              onChanged: (selected) {
                if (selected != null) {
                  onLocaleChange(selected);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
