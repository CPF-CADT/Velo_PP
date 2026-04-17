import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/ui/screens/station/view_model/station_view_model.dart';
import 'package:velo_pp/ui/screens/station/widgets/slots_grid.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/core/theme/app_colors.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/model/station.dart';
import 'package:velo_pp/l10n/app_localizations.dart';

class StationContent extends StatefulWidget {
  final Station station;
  final VoidCallback? onOpenPassesTap;

  const StationContent({
    super.key,
    required this.station,
    this.onOpenPassesTap,
  });

  @override
  State<StationContent> createState() => _StationContentState();
}

class _StationContentState extends State<StationContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StationViewModel>().loadSlots(widget.station.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Consumer<StationViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.slots.state == AsyncValueState.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.station.name),
              backgroundColor: AppColors.primary,
              centerTitle: true,
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (viewModel.slots.state == AsyncValueState.error) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.station.name),
              backgroundColor: AppColors.primary,
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: AppSpacing.s48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${loc.get('error')}: ${viewModel.slots.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => viewModel.loadSlots(widget.station.id),
                    child: Text(loc.get('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        final slots = viewModel.slots.data ?? [];
        final availableSlots = slots
            .where((slot) => slot.status == 'available')
            .length;
        final occupiedSlots = slots
            .where((slot) => slot.status == 'occupied')
            .length;
        final selectedDock = viewModel.selectedDock;
        final selectedBikeModel = selectedDock == null
            ? null
            : viewModel.getBikeModel(selectedDock.bikeId);
        final hasActiveRide = viewModel.hasActiveRide;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.station.name),
            backgroundColor: AppColors.primary,
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: AppSpacing.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.station.name,
                  style: AppTextStyles.headingLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  hasActiveRide
                      ? 'You already have an active ride. Return it before booking another bike.'
                      : 'Select one occupied slot to book a bike.',
                  style: AppTextStyles.body.copyWith(color: AppColors.gray600),
                ),
                if (hasActiveRide) ...[
                  const SizedBox(height: AppSpacing.s10),
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.all(AppSpacing.s10),
                    decoration: BoxDecoration(
                      color: AppColors.withAlpha(AppColors.secondary, 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.r10),
                      border: Border.all(
                        color: AppColors.withAlpha(AppColors.secondary, 0.35),
                      ),
                    ),
                    child: Text(
                      'Booking is locked until your current ride is returned.',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.s20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bike Occupied',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '$occupiedSlots ${loc.get('bikes')}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Available Slots',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '$availableSlots ${loc.get('slots')}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s20),
                Expanded(
                  child: SlotsGrid(
                    slots: slots,
                    selectedDockId: viewModel.selectedDockId,
                    bikeLabelBuilder: (dock) =>
                        viewModel.getBikeModel(dock.bikeId),
                    onSlotDismiss: hasActiveRide
                        ? null
                        : (dockId) =>
                              _bookBikeFromDismiss(context, viewModel, dockId),
                    onSlotTap: hasActiveRide
                        ? (_) {}
                        : (dockId) => viewModel.selectDock(dockId),
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                if (selectedDock != null)
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColors.withAlpha(AppColors.primary, 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.r10),
                      border: Border.all(
                        color: AppColors.withAlpha(AppColors.primary, 0.25),
                      ),
                    ),
                    child: Text(
                      'Selected: Slot ${selectedDock.slotNumber} - Bike $selectedBikeModel',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.s12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        (hasActiveRide ||
                            selectedDock == null ||
                            viewModel.isBooking)
                        ? null
                        : () => _bookBike(context, viewModel),
                    icon: viewModel.isBooking
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.pedal_bike),
                    label: Text(
                      viewModel.isBooking ? 'Booking...' : 'Book selected bike',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _bookBike(
    BuildContext context,
    StationViewModel viewModel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await viewModel.bookSelectedBike();
      if (!context.mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(content: Text('Bike booked successfully')),
      );
      Navigator.pop(context);
    } on PassRequiredException {
      final action = await _showPassChoiceDialog(context);
      if (action == null || !context.mounted) {
        return;
      }

      if (action == 'single_pass') {
        final paid = await _showSingleTicketPaymentSheet(context);
        if (paid != true || !context.mounted) {
          return;
        }

        try {
          await viewModel.bookSelectedBike(purchasePassId: 'single_pass');
          if (!context.mounted) {
            return;
          }
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Ticket paid and bike booked successfully'),
            ),
          );
          Navigator.pop(context);
        } catch (error) {
          messenger.showSnackBar(SnackBar(content: Text(error.toString())));
        }
        return;
      }

      if (action == 'buy_pass') {
        if (widget.onOpenPassesTap != null) {
          Navigator.pop(context);
          widget.onOpenPassesTap!.call();
          return;
        }

        messenger.showSnackBar(
          const SnackBar(
            content: Text('Pass tab is not available from this entry point'),
          ),
        );
      }
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _bookBikeFromDismiss(
    BuildContext context,
    StationViewModel viewModel,
    String dockId,
  ) async {
    viewModel.selectDock(dockId);
    await _bookBike(context, viewModel);
  }

  Future<String?> _showPassChoiceDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pass Required'),
          content: const Text(
            'You do not have an active pass. Choose an option to continue booking.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'single_pass'),
              child: const Text('Single Ticket'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'buy_pass'),
              child: const Text('Buy Pass'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showSingleTicketPaymentSheet(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.r20),
          topRight: Radius.circular(AppSpacing.r20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: AppSpacing.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Single Ticket Payment',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.s10),
                Text(
                  'Complete payment before booking this bike.',
                  style: AppTextStyles.body.copyWith(color: AppColors.gray700),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: AppColors.withAlpha(AppColors.primary, 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.r10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Single Ticket',
                        style: AppTextStyles.body,
                      ),
                      Text(
                        'Pay \$1',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirm Payment'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
