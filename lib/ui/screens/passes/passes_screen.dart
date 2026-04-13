import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/screens/passes/view_model/passes_view_model.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class PassesScreen extends StatelessWidget {
  const PassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PassesViewModel(
        authRepository: context.read<AuthRepository>(),
        passesRepository: context.read<PassesRepository>(),
      )..loadPasses(),
      child: const _PassesView(),
    );
  }
}

class _PassesView extends StatelessWidget {
  const _PassesView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<PassesViewModel>();
    final state = viewModel.passes;

    if (state.state == AsyncValueState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.state == AsyncValueState.error) {
      return Center(child: Text(state.error.toString()));
    }

    final data = state.data;
    if (data == null || data.passes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.style, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              loc.get('yourPasses'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.get('noPassesYet'),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (data.activePass != null)
          _buildActivePassCard(context, data.activePass!.passId),
        const SizedBox(height: 12),
        Text(
          loc.get('passes'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...data.passes.map(
          (pass) => Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.teal),
              title: Text(pass.name),
              subtitle: Text('${pass.durationHours} ${loc.get('hoursShort')}'),
              trailing: Text(
                '\$${pass.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePassCard(BuildContext context, String passId) {
    final repo = context.read<PassesRepository>();
    final pass = repo.getPassById(passId);

    if (pass == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.teal[50],
      child: ListTile(
        leading: const Icon(Icons.verified, color: Colors.teal),
        title: Text(pass.name),
        subtitle: Text(AppLocalizations.of(context).get('activePass')),
        trailing: Text(
          '\$${pass.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
