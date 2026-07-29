import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../data/mock/mock_seed.dart';

Future<String?> showVisitLocationSheet(BuildContext context, String? current) {
  return showAppBottomSheet<String>(
    context: context,
    title: 'Meeting location',
    isScrollControlled: false,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: MockSeed.visitLocations.map((location) {
        final selected = location == current;
        return ListTile(
          title: Text(location, style: AppTypography.body()),
          trailing: selected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
          onTap: () => Navigator.of(context).pop(location),
        );
      }).toList(),
    ),
  );
}
