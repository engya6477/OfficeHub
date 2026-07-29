import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/visit.dart';
import '../application/visits_controller.dart';
import 'register_visitor_screen.dart';
import 'visit_details_screen.dart';

class VisitorsTabScreen extends StatefulWidget {
  const VisitorsTabScreen({super.key});

  @override
  State<VisitorsTabScreen> createState() => _VisitorsTabScreenState();
}

class _VisitorsTabScreenState extends State<VisitorsTabScreen> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitsController>();
    final list = _segment == 0 ? visits.upcoming : visits.history;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                0,
              ),
              child: Text(
                'Visitors',
                style: AppTypography.heading().copyWith(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterVisitorScreen(),
                    ),
                  ),
                  icon: const Icon(Iconsax.user_add),
                  label: const Text('Register visitor'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text('My visits', style: AppTypography.sectionTitle()),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _SegmentToggle(
                value: _segment,
                labels: const ['Upcoming', 'History'],
                onChanged: (v) => setState(() => _segment = v),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: Iconsax.profile_2user,
                      title: _segment == 0
                          ? 'No upcoming visits'
                          : 'No visit history yet',
                      message: _segment == 0
                          ? 'Register a visitor to see them listed here.'
                          : 'Your past and cancelled visits will appear here.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) =>
                          _VisitListTile(visit: list[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({
    required this.value,
    required this.labels,
    required this.onChanged,
  });

  final int value;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: selected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: AppTypography.listTitle(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _VisitListTile extends StatelessWidget {
  const _VisitListTile({required this.visit});

  final Visit visit;

  @override
  Widget build(BuildContext context) {
    final tone = switch (visit.displayStatusLabel) {
      'Cancelled' => StatusTone.error,
      'Completed' => StatusTone.neutral,
      _ => StatusTone.info,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VisitDetailsScreen(visitId: visit.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.visitorAccentSurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Icon(
                Iconsax.profile_2user,
                size: 20,
                color: AppColors.visitorAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(visit.visitorName, style: AppTypography.listTitle()),
                  const SizedBox(height: 2),
                  Text(
                    '${visit.purpose.label} · ${visit.meetingLocation}',
                    style: AppTypography.cardMeta(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(label: visit.displayStatusLabel, tone: tone),
                const SizedBox(height: 4),
                Text(
                  DateTimeFormat.time(visit.arrivalTime),
                  style: AppTypography.cardMeta(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
