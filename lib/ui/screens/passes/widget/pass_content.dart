import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/core/theme/app_spacing.dart';
import 'package:velo_pp/core/theme/app_text_styles.dart';
import 'package:velo_pp/ui/screens/passes/view_model/passes_view_model.dart';
import 'package:velo_pp/ui/screens/passes/widget/pass_card.dart';

class PassContent extends StatelessWidget {
  const PassContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PassesViewModel>();
    final state = viewModel.passes; // store async value states

    if (state.state == AsyncValueState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.state == AsyncValueState.error) {
      return Center(child: Text(state.error.toString()));
    }

    final data = state.data;
    if (data == null || data.passes.isEmpty) {
      return const Center(child: Text('No passes available'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: AppSpacing.all(AppSpacing.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Membership Plan', style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.sm),
            Text('Choose your pace.', style: AppTextStyles.headingLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Select the plan that fits your lifestyle.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),

            ...data.passes.map((pass) {
              final status = viewModel.getPassStatus(pass.id);

              String buttonLabel;
              bool isFeatured = false;
              bool isDisabled = false;

              if (status == PassStatus.active) {
                final days = viewModel.getActiveDaysRemaining();
                buttonLabel = days != null
                    ? 'Active ($days day left)'
                    : 'Active';
                isFeatured = true;
                isDisabled = true;
              } else if (status == PassStatus.expired) {
                buttonLabel = 'Expired';
                isDisabled = true;
              } else if (status == PassStatus.purchasing) {
                buttonLabel = 'Purchasing.....';
                isDisabled = true;
              } else {
                buttonLabel = 'Select a Pass';
              }

              return Padding(
                padding: AppSpacing.only(bottom: AppSpacing.md),
                child: PassCard(
                  title: pass.name,
                  price: '\$${pass.price.toStringAsFixed(0)}',
                  description: 'Available for ${pass.durationHours} hours',
                  features: pass.features,
                  buttonLabel: buttonLabel,
                  isFeatured: isFeatured,
                  onPressed: isDisabled
                      ? () {}
                      : () => viewModel.buyPass(pass.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
