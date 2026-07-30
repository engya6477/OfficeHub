import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/date_selection_sheet.dart';
import '../../../core/widgets/time_selection_sheet.dart';
import '../application/visit_draft.dart';
import 'review_visit_screen.dart';
import 'visit_location_sheet.dart';
import 'visit_purpose_sheet.dart';
import 'widgets/visit_selector_field.dart';
import 'widgets/visit_step_indicator.dart';

/// Step 2 of 2: visit details (date, arrival time, purpose, location).
class RegisterVisitStep2Screen extends StatefulWidget {
  const RegisterVisitStep2Screen({
    super.key,
    required this.draft,
    this.editingVisitId,
  });

  final VisitDraft draft;
  final String? editingVisitId;

  bool get isEditing => editingVisitId != null;

  @override
  State<RegisterVisitStep2Screen> createState() =>
      _RegisterVisitStep2ScreenState();
}

class _RegisterVisitStep2ScreenState extends State<RegisterVisitStep2Screen> {
  late VisitDraft _draft = widget.draft;

  Future<void> _pickDate() async {
    final date = await showDateSelectionSheet(
      context,
      initialDate: _draft.visitDate,
    );
    if (date != null) setState(() => _draft = _draft.copyWith(visitDate: date));
  }

  Future<void> _pickTime() async {
    final time = await showTimeSelectionSheet(
      context,
      initialTime: _draft.arrivalTime,
      title: 'Select arrival time',
    );
    if (time != null) {
      setState(() => _draft = _draft.copyWith(arrivalTime: time));
    }
  }

  Future<void> _pickPurpose() async {
    final purpose = await showVisitPurposeSheet(context, _draft.purpose);
    if (purpose != null) {
      setState(() => _draft = _draft.copyWith(purpose: purpose));
    }
  }

  Future<void> _pickLocation() async {
    final location = await showVisitLocationSheet(
      context,
      _draft.meetingLocation,
    );
    if (location != null) {
      setState(() => _draft = _draft.copyWith(meetingLocation: location));
    }
  }

  void _reviewVisit() {
    if (!_draft.isStep2Complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReviewVisitScreen(
          draft: _draft,
          editingVisitId: widget.editingVisitId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(widget.isEditing ? 'Edit visit' : 'Register visitor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isEditing) ...[
                const VisitStepIndicator(currentStep: 2),
                const SizedBox(height: AppSpacing.xxl),
              ],
              Text('Visitor information', style: AppTypography.sectionTitle()),
              const SizedBox(height: 4),
              Text('Who is coming to visit?', style: AppTypography.authBody()),
              const SizedBox(height: AppSpacing.xxl),
              VisitSelectorField(
                label: 'Visit date',
                icon: AppIcons.calendar,
                placeholder: 'Select date',
                value: _draft.visitDate == null
                    ? null
                    : DateTimeFormat.friendlyDate(_draft.visitDate!),
                onTap: _pickDate,
              ),
              const SizedBox(height: AppSpacing.lg),
              VisitSelectorField(
                label: 'Arrival time',
                icon: AppIcons.clock,
                placeholder: 'Select time',
                value: _draft.arrivalTime == null
                    ? null
                    : DateTimeFormat.time(_draft.arrivalTime!),
                onTap: _pickTime,
              ),
              const SizedBox(height: AppSpacing.lg),
              VisitSelectorField(
                label: 'Visit purpose',
                icon: AppIcons.documentText,
                placeholder: 'Select purpose',
                value: _draft.purpose?.label,
                onTap: _pickPurpose,
              ),
              const SizedBox(height: AppSpacing.lg),
              VisitSelectorField(
                label: 'Meeting location',
                icon: AppIcons.locationTick,
                placeholder: 'Select location',
                value: _draft.meetingLocation,
                onTap: _pickLocation,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(label: 'Review visit', onPressed: _reviewVisit),
            ],
          ),
        ),
      ),
    );
  }
}
