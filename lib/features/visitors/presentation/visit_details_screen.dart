import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/visit.dart';
import '../../../data/repositories/visit_repository.dart';
import '../application/visit_draft.dart';
import '../application/visits_controller.dart';
import 'register_visitor_screen.dart';

class VisitDetailsScreen extends StatelessWidget {
  const VisitDetailsScreen({super.key, required this.visitId});

  final String visitId;

  Future<void> _cancel(BuildContext context, Visit visit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel visit?'),
        content: const Text('This visit will be cancelled and moved to your history.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Keep visit')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cancel visit')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      context.read<VisitsController>().cancelVisit(visit.id);
      if (context.mounted) Navigator.of(context).pop();
    } on VisitException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitsController>();
    final visit = visits.getById(visitId);

    if (visit == null) {
      return const Scaffold(body: Center(child: Text('Visit not found.')));
    }

    final tone = switch (visit.displayStatusLabel) {
      'Cancelled' => StatusTone.error,
      'Completed' => StatusTone.neutral,
      _ => StatusTone.info,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Visit details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(visit.visitorName, style: AppTypography.heading().copyWith(fontSize: 22))),
                  StatusBadge(label: visit.displayStatusLabel, tone: tone),
                ],
              ),
              const SizedBox(height: 4),
              Text(visit.visitorPhone, style: AppTypography.cardMeta(color: AppColors.textMuted)),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row('Date', DateTimeFormat.friendlyDate(visit.visitDate)),
                    _Row('Arrival time', DateTimeFormat.time(visit.arrivalTime)),
                    _Row('Purpose', visit.purpose.label),
                    _Row('Location', visit.meetingLocation),
                  ],
                ),
              ),
              const Spacer(),
              if (visit.isEditable) ...[
                AppButton(
                  label: 'Edit visit',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterVisitorScreen(
                        editingVisitId: visit.id,
                        initialDraft: VisitDraft.fromVisit(visit),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(label: 'Cancel', onPressed: () => _cancel(context, visit)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body(color: AppColors.textMuted))),
          Text(value, style: AppTypography.listTitle()),
        ],
      ),
    );
  }
}
