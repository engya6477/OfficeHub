import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/visit.dart';
import 'visit_details_screen.dart';

class VisitConfirmationScreen extends StatelessWidget {
  const VisitConfirmationScreen({super.key, required this.visitorName, required this.visit});

  final String visitorName;
  final Visit visit;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(title: const Text('Review visit'), automaticallyImplyLeading: false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(color: AppColors.successSurface, shape: BoxShape.circle),
                  child: const Icon(Iconsax.tick_circle, color: AppColors.success, size: 36),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Visitor registered', style: AppTypography.heading().copyWith(fontSize: 22)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$visitorName is expected on ${DateTimeFormat.friendlyDate(visit.visitDate)} '
                  'at ${DateTimeFormat.time(visit.arrivalTime)}.',
                  style: AppTypography.body(color: AppColors.textMuted),
                ),
                const Spacer(),
                AppButton(
                  label: 'View visit',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => VisitDetailsScreen(visitId: visit.id)),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Done',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
