import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Two text segments joined by a "·" separator, matching the exact history
/// card row styling (e.g. "Mon, Jul 20 · 9:00 AM–10:00 AM").
class DotRow extends StatelessWidget {
  const DotRow(this.first, this.second, {super.key, this.meta = false});

  final String first;
  final String second;

  /// Use the smaller meta style (attendees/duration row) instead of the
  /// primary date/time row style.
  final bool meta;

  @override
  Widget build(BuildContext context) {
    final style = meta
        ? AppTypography.historyMeta()
        : AppTypography.historyRow();
    final dotStyle = meta
        ? AppTypography.historyMeta(color: AppColors.textDisabled)
        : AppTypography.historyRow(color: const Color(0xFFD1D5DC));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(first, style: style),
        Text(' · ', style: dotStyle),
        Text(second, style: style),
      ],
    );
  }
}
