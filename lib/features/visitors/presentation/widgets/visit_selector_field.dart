import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_icon.dart';

/// Tappable field matching the Figma "Input" component used on Register
/// Visit — Step 2: a label above a white pill-radius box containing a
/// leading icon and the selected value (or placeholder).
class VisitSelectorField extends StatelessWidget {
  const VisitSelectorField({
    super.key,
    required this.label,
    required this.icon,
    required this.placeholder,
    this.value,
    required this.onTap,
  });

  final String label;
  final String icon;
  final String placeholder;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.inputLabel()),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                AppIcon(icon, color: AppColors.iconFieldStrong),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  value ?? placeholder,
                  style: value != null
                      ? AppTypography.body()
                      : AppTypography.bodyPlaceholder(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
