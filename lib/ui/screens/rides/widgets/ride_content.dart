import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/l10n/app_localizations.dart';
import 'package:velo_pp/ui/screens/rides/view_model/rides_view_model.dart';
import 'package:velo_pp/ui/states/ride_state.dart';

class RideContent extends StatelessWidget {
  const RideContent({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<RidesViewModel>();
    final globalBooking = context.watch<RideState>().booking;
    final state = viewModel.rides;
    final theme = Theme.of(context);

    final hasGlobalActiveRide =
        globalBooking != null && globalBooking.status.toLowerCase() == 'active';

    final data = List<RideSummary>.from(state.data ?? const []);
    if (globalBooking != null &&
        !data.any((summary) => summary.booking.id == globalBooking.id)) {
      data.insert(0, viewModel.summaryFromBooking(globalBooking));
    }

    if (state.state == AsyncValueState.loading && !hasGlobalActiveRide) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.state == AsyncValueState.error && data.isEmpty) {
      return Center(child: Text(state.error.toString()));
    }

    if (data.isEmpty) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.s20,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.s40),
              const Icon(
                Icons.directions_bike,
                size: AppSpacing.s92,
                color: AppColors.gray300,
              ),
              const SizedBox(height: AppSpacing.s20),
              Text(
                loc.get('yourRides'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                loc.get('noRidesYet'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SummaryCard(totalRides: 0),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppSpacing.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.s12,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.get('yourRides'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track your recent trips and status',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SummaryCard(totalRides: data.length),
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    'Recent rides',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: AppSpacing.fromLTRB(
              AppSpacing.s20,
              0,
              AppSpacing.s20,
              AppSpacing.s20,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final summary = data[index];
                return Padding(
                  padding: AppSpacing.only(bottom: AppSpacing.s12),
                  child: _RideCard(
                    bikeName: summary.bike?.model ?? loc.get('bike'),
                    startStation: summary.startStation?.name ?? '-',
                    endStation: summary.endStation?.name ?? '-',
                    status: summary.booking.status,
                    isReturning: viewModel.isReturning(summary.booking.id),
                    onReturnBike:
                        summary.booking.status.toLowerCase() == 'active'
                        ? () async {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              final result = await viewModel.returnBike(
                                summary,
                              );
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Return to ${result.station.name}, slot ${result.dock.slotNumber}',
                                  ),
                                ),
                              );
                            } catch (error) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            }
                          }
                        : null,
                  ),
                );
              }, childCount: data.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totalRides});

  final int totalRides;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppSpacing.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.r18),
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          Container(
            height: AppSpacing.s44,
            width: AppSpacing.s44,
            decoration: BoxDecoration(
              color: AppColors.withAlpha(AppColors.white, 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.r14),
            ),
            child: const Icon(Icons.route, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total rides',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.withAlpha(AppColors.white, 0.8),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$totalRides',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.withAlpha(AppColors.white, 0.7),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.bikeName,
    required this.startStation,
    required this.endStation,
    required this.status,
    required this.isReturning,
    required this.onReturnBike,
  });

  final String bikeName;
  final String startStation;
  final String endStation;
  final String status;
  final bool isReturning;
  final VoidCallback? onReturnBike;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: AppSpacing.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.r16),
        border: Border.all(color: AppColors.withAlpha(AppColors.gray500, 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.withAlpha(AppColors.black, 0.04),
            blurRadius: AppSpacing.s12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.withAlpha(AppColors.primary, 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.s12),
                ),
                child: const Icon(Icons.pedal_bike, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bikeName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      isActive ? startStation : '$startStation -> $endStation',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(status),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              _InfoPill(icon: Icons.place, label: startStation),
              if (!isActive) ...[
                const SizedBox(width: AppSpacing.sm),
                _InfoPill(icon: Icons.flag, label: endStation),
              ],
            ],
          ),
          if (onReturnBike != null) ...[
            const SizedBox(height: AppSpacing.s12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isReturning ? null : onReturnBike,
                icon: isReturning
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.assignment_turned_in),
                label: Text(isReturning ? 'Returning...' : 'Return bike'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final normalized = status.toLowerCase();
    Color color;

    switch (normalized) {
      case 'active':
        color = AppColors.primary;
        break;
      case 'completed':
        color = AppColors.gray500;
        break;
      default:
        color = AppColors.secondary;
        break;
    }

    return Container(
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.pill),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.s10,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.withAlpha(AppColors.gray500, 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.s12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSpacing.md, color: AppColors.gray600),
            const SizedBox(width: AppSpacing.s6),
            Flexible(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.gray700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
