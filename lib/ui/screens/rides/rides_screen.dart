import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/bikes/bikes_repository.dart';
import 'package:velo_pp/data/repositories/bookings/bookings_repository.dart';
import 'package:velo_pp/data/repositories/stations/stations_repository.dart';
import 'package:velo_pp/ui/screens/rides/view_model/rides_view_model.dart';
import 'package:velo_pp/core/utils/async_value.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RidesViewModel(
        authRepository: context.read<AuthRepository>(),
        bookingsRepository: context.read<BookingsRepository>(),
        stationsRepository: context.read<StationsRepository>(),
        bikesRepository: context.read<BikesRepository>(),
      )..loadRides(),
      child: const _RidesView(),
    );
  }
}

class _RidesView extends StatelessWidget {
  const _RidesView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<RidesViewModel>();
    final state = viewModel.rides;

    if (state.state == AsyncValueState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.state == AsyncValueState.error) {
      return Center(child: Text(state.error.toString()));
    }

    final data = state.data;
    if (data == null || data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bike, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              loc.get('yourRides'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.get('noRidesYet'),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final summary = data[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.pedal_bike, color: Colors.teal),
            title: Text(summary.bike?.model ?? loc.get('bike')),
            subtitle: Text(
              '${summary.startStation?.name ?? '-'} → '
              '${summary.endStation?.name ?? '-'}',
            ),
            trailing: _buildStatusChip(summary.booking.status),
          ),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemCount: data.length,
    );
  }

  Widget _buildStatusChip(String status) {
    final normalized = status.toLowerCase();
    Color color;

    switch (normalized) {
      case 'active':
        color = Colors.teal;
        break;
      case 'completed':
        color = Colors.grey;
        break;
      default:
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
