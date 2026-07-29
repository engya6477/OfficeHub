import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum StatusTone { info, success, error, neutral }

/// Small pill badge used to mark booking/visit status in list and detail views.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (tone) {
      StatusTone.info => (AppColors.primarySurface, AppColors.primary),
      StatusTone.success => (AppColors.successSurface, AppColors.success),
      StatusTone.error => (const Color(0xFFFFF1F1), AppColors.error),
      StatusTone.neutral => (AppColors.chipBackground, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(label, style: AppTypography.cardMeta(color: fg)),
    );
  }
}
