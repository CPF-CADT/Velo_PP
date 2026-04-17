import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/core/utils/async_value.dart';
import 'package:velo_pp/ui/screens/passes/view_model/passes_view_model.dart';
import 'package:velo_pp/ui/screens/passes/widget/pass_card.dart';


class PassContent extends StatelessWidget {
  const PassContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PassesViewModel>();  
    final state = viewModel.passes;   // store async value states

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Membership Plan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your pace.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the plan that fits your lifestyle.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            ...data.passes.map((pass) {
              final status = viewModel.getPassStatus(pass.id);

              String buttonLabel;
              bool isFeatured = false;
              bool isDisabled = false;

              if (status == PassStatus.active) {
                final days = viewModel.getActiveDaysRemaining();
                buttonLabel = days != null ? 'Active ($days day left)' : 'Active';
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
                padding: const EdgeInsets.only(bottom: 16),
                child: PassCard(
                  title: pass.name,
                  price: '\$${pass.price.toStringAsFixed(0)}',
                  description: 'Valid for ${pass.durationHours} hours',
                  features: pass.features,
                  buttonLabel: buttonLabel,
                  isFeatured: isFeatured,
                  onPressed: isDisabled ? () {} : () => viewModel.buyPass(pass.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}