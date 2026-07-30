import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Segmented progress indicator on the Register Visit steps ("Step 1 of 2" /
/// "Step 2 of 2"), matching the Figma "Container" stepper component: each
/// completed/active segment is a 24pt-wide filled pill, each pending segment
/// a shorter 16pt-wide neutral pill.
class VisitStepIndicator extends StatelessWidget {
  const VisitStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 2,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final active = index < currentStep;
            return Padding(
              padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
              child: Container(
                width: active ? 24 : 16,
                height: 4,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: AppSpacing.lg),
        Text(
          'Step $currentStep of $totalSteps',
          style: AppTypography.stepLabel(),
        ),
      ],
    );
  }
}
