import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/business_hours.dart';
import '../utils/date_time_format.dart';
import 'app_bottom_sheet.dart';
import 'selectable_chip.dart';

/// Time picker sheet (Figma "Select start time") offering half-hour slots
/// across office hours (8:00 AM - 6:00 PM).
Future<TimeOfDay?> showTimeSelectionSheet(BuildContext context, {TimeOfDay? initialTime, String title = 'Select start time'}) {
  return showAppBottomSheet<TimeOfDay>(
    context: context,
    title: title,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: BusinessHours.availableStartTimes().map((slot) {
              final selected = initialTime != null && slot.hour == initialTime.hour && slot.minute == initialTime.minute;
              return SelectableChip(
                label: DateTimeFormat.time(slot),
                selected: selected,
                onTap: () => Navigator.of(context).pop(slot),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Office hours: 8:00 AM – 6:00 PM', style: AppTypography.cardMeta(color: AppColors.textMuted)),
        ],
      ),
    ),
  );
}
