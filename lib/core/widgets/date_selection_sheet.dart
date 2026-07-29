import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/business_hours.dart';
import 'app_bottom_sheet.dart';

/// Date picker sheet (Figma "Select date"). When [restrictToBusinessDays] is
/// true, Friday/Saturday are disabled per the meeting room booking rule that
/// business days are Sunday-Thursday. Visitor registration has no such
/// restriction in the assessment's business rules, so it passes false.
Future<DateTime?> showDateSelectionSheet(
  BuildContext context, {
  DateTime? initialDate,
  bool restrictToBusinessDays = true,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return showAppBottomSheet<DateTime>(
    context: context,
    title: 'Select date',
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (restrictToBusinessDays) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Available Sunday – Thursday only',
              style: AppTypography.cardMeta(color: AppColors.textMuted),
            ),
          ],
          SizedBox(
            height: 340,
            child: CalendarDatePicker(
              initialDate: initialDate != null && !initialDate.isBefore(today) ? initialDate : today,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365)),
              selectableDayPredicate: restrictToBusinessDays ? BusinessHours.isBusinessDay : null,
              onDateChanged: (date) => Navigator.of(context).pop(date),
            ),
          ),
        ],
      ),
    ),
  );
}
