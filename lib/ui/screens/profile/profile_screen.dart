import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/core/widgets/app_card.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(loc.get('profile'))),
      body: SingleChildScrollView(
        padding: AppSpacing.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, loc, viewModel),
            const SizedBox(height: AppSpacing.md),
            Text(loc.get('userSettings'), style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.s12),
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

    return AppCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: AppSpacing.s34,
            backgroundColor: AppColors.primary,
            child: Text(
              viewModel.initials,
              style: AppTextStyles.title.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            user.displayName,
            style: AppTextStyles.title,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user.email,
            style: AppTextStyles.caption.copyWith(color: AppColors.gray600),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(loc.get('email'), user.email),
          const SizedBox(height: AppSpacing.sm),
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
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.primary),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(loc.get('language'), style: AppTextStyles.subtitle),
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
            style: AppTextStyles.caption.copyWith(color: AppColors.gray500),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
