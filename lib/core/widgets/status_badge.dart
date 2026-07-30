import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum StatusTone { info, success, error, neutral }

/// Pill status badge matching the exact "StatusBadge" component from the
/// Rooms/Visitors history cards (Upcoming/Past/Cancelled).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (tone) {
      StatusTone.info => (
        AppColors.statusUpcomingBg,
        AppColors.statusUpcomingFg,
      ),
      StatusTone.success => (AppColors.successSurface, AppColors.success),
      StatusTone.error => (
        AppColors.statusCancelledBg,
        AppColors.statusCancelledFg,
      ),
      StatusTone.neutral => (AppColors.statusPastBg, AppColors.statusPastFg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: AppTypography.statusBadge(color: fg)),
    );
  }
}
