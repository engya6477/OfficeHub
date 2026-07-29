import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../data/models/visit.dart';

Future<VisitPurpose?> showVisitPurposeSheet(BuildContext context, VisitPurpose? current) {
  return showAppBottomSheet<VisitPurpose>(
    context: context,
    title: 'Visit purpose',
    isScrollControlled: false,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: VisitPurpose.values.map((purpose) {
        final selected = purpose == current;
        return ListTile(
          title: Text(purpose.label, style: AppTypography.body()),
          trailing: selected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
          onTap: () => Navigator.of(context).pop(purpose),
        );
      }).toList(),
    ),
  );
}
