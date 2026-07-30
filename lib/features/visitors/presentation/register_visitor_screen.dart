import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/date_selection_sheet.dart';
import '../../../core/widgets/time_selection_sheet.dart';
import '../application/visit_draft.dart';
import 'review_visit_screen.dart';
import 'visit_location_sheet.dart';
import 'visit_purpose_sheet.dart';

/// Step 1 of 2: visitor information + visit details. Reused for both
/// registering a new visitor and editing an eligible upcoming visit.
class RegisterVisitorScreen extends StatefulWidget {
  const RegisterVisitorScreen({
    super.key,
    this.editingVisitId,
    this.initialDraft,
  });

  final String? editingVisitId;
  final VisitDraft? initialDraft;

  bool get isEditing => editingVisitId != null;

  @override
  State<RegisterVisitorScreen> createState() => _RegisterVisitorScreenState();
}

class _RegisterVisitorScreenState extends State<RegisterVisitorScreen> {
  late final _nameController = TextEditingController(
    text: widget.initialDraft?.visitorName ?? '',
  );
  late final _phoneController = TextEditingController(
    text: widget.initialDraft?.visitorPhone ?? '',
  );
  late VisitDraft _draft = widget.initialDraft ?? const VisitDraft();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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

  void _continue() {
    final draft = _draft.copyWith(
      visitorName: _nameController.text,
      visitorPhone: _phoneController.text,
    );
    if (!draft.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReviewVisitScreen(
          draft: draft,
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
                Text('Step 1 of 2', style: AppTypography.caption()),
                const SizedBox(height: 4),
              ],
              Text('Visitor information', style: AppTypography.feedbackTitle()),
              const SizedBox(height: 4),
              Text('Who is coming to visit?', style: AppTypography.authBody()),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Visitor Name',
                controller: _nameController,
                hintText: 'Full name',
                required: true,
                leadingIcon: Iconsax.user,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Phone Number',
                controller: _phoneController,
                hintText: '+966 5X XXX XXXX',
                required: true,
                leadingIcon: Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldTile(
                icon: Iconsax.calendar_1,
                label: 'Visit date',
                value: _draft.visitDate == null
                    ? 'Select date'
                    : DateTimeFormat.friendlyDate(_draft.visitDate!),
                onTap: _pickDate,
              ),
              const SizedBox(height: AppSpacing.md),
              _FieldTile(
                icon: Iconsax.clock,
                label: 'Arrival time',
                value: _draft.arrivalTime == null
                    ? 'Select time'
                    : DateTimeFormat.time(_draft.arrivalTime!),
                onTap: _pickTime,
              ),
              const SizedBox(height: AppSpacing.md),
              _FieldTile(
                icon: Iconsax.briefcase,
                label: 'Visit purpose',
                value: _draft.purpose?.label ?? 'Select purpose',
                onTap: _pickPurpose,
              ),
              const SizedBox(height: AppSpacing.md),
              _FieldTile(
                icon: Iconsax.location,
                label: 'Meeting location',
                value: _draft.meetingLocation ?? 'Select location',
                onTap: _pickLocation,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(label: 'Continue', onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textMutedAlt),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypography.inputLabel()),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: AppTypography.body(),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppColors.textMutedAlt,
            ),
          ],
        ),
      ),
    );
  }
}
