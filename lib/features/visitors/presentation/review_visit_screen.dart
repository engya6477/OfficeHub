import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/visit_repository.dart';
import '../application/visit_draft.dart';
import '../application/visits_controller.dart';
import 'visit_confirmation_screen.dart';

class ReviewVisitScreen extends StatefulWidget {
  const ReviewVisitScreen({
    super.key,
    required this.draft,
    this.editingVisitId,
  });

  final VisitDraft draft;
  final String? editingVisitId;

  @override
  State<ReviewVisitScreen> createState() => _ReviewVisitScreenState();
}

class _ReviewVisitScreenState extends State<ReviewVisitScreen> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final controller = context.read<VisitsController>();
    final draft = widget.draft;
    try {
      final visit = widget.editingVisitId != null
          ? controller.updateVisit(
              visitId: widget.editingVisitId!,
              visitorName: draft.visitorName,
              visitorPhone: draft.visitorPhone,
              visitDate: draft.visitDate!,
              arrivalTime: draft.arrivalTime!,
              purpose: draft.purpose!,
              meetingLocation: draft.meetingLocation!,
            )
          : controller.createVisit(
              visitorName: draft.visitorName,
              visitorPhone: draft.visitorPhone,
              visitDate: draft.visitDate!,
              arrivalTime: draft.arrivalTime!,
              purpose: draft.purpose!,
              meetingLocation: draft.meetingLocation!,
            );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VisitConfirmationScreen(
            visitorName: visit.visitorName,
            visit: visit,
          ),
        ),
      );
    } on VisitException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final isEditing = widget.editingVisitId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Review visit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEditing) ...[
                Text('Step 2 of 2', style: AppTypography.caption()),
                const SizedBox(height: 4),
              ],
              Text(
                isEditing
                    ? 'Make sure everything looks right before saving.'
                    : 'Make sure everything looks right before registering.',
                style: AppTypography.authBody(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Visitor information',
                rows: {'Name': draft.visitorName, 'Phone': draft.visitorPhone},
              ),
              const SizedBox(height: AppSpacing.lg),
              _Section(
                title: 'Visit information',
                rows: {
                  'Date': DateTimeFormat.friendlyDate(draft.visitDate!),
                  'Arrival time': DateTimeFormat.time(draft.arrivalTime!),
                  'Purpose': draft.purpose!.label,
                  'Location': draft.meetingLocation!,
                },
              ),
              const Spacer(),
              AppButton(
                label: isEditing ? 'Save changes' : 'Register visitor',
                loading: _submitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Edit details',
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final Map<String, String> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(title, style: AppTypography.sectionTitle()),
          const SizedBox(height: AppSpacing.sm),
          ...rows.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(e.key, style: AppTypography.authBody())),
                  Flexible(
                    child: Text(
                      e.value,
                      style: AppTypography.listTitle(),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
