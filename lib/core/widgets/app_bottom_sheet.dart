import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shows a modal bottom sheet with the drag handle + title + divider header
/// used by the Filters / Select date / Select time / Purpose / Location sheets.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 144,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF999999),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text(title, style: AppTypography.screenTitle()),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Flexible(child: builder(context)),
          ],
        ),
      ),
    ),
  );
}
