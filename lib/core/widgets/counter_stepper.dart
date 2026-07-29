import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Numeric +/- stepper (Figma "Stepper" component) used for attendee count.
class CounterStepper extends StatelessWidget {
  const CounterStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 50,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Iconsax.minus,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Center(child: Text('$value', style: AppTypography.stepperValue())),
          ),
          _StepperButton(
            icon: Iconsax.add,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 46,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: onTap == null ? AppColors.placeholder : AppColors.textMuted),
      ),
    );
  }
}
