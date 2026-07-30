import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/visit_draft.dart';
import 'register_visit_step2_screen.dart';
import 'widgets/visit_step_indicator.dart';

/// Step 1 of 2: visitor information (name, phone, email, company). Reused
/// for both registering a new visitor and editing an eligible upcoming visit.
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
  late final _emailController = TextEditingController(
    text: widget.initialDraft?.visitorEmail ?? '',
  );
  late final _companyController = TextEditingController(
    text: widget.initialDraft?.visitorCompany ?? '',
  );
  late final VisitDraft _draft = widget.initialDraft ?? const VisitDraft();

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _nameController,
      _phoneController,
      _emailController,
      _companyController,
    ]) {
      controller.addListener(_onFieldChanged);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _onFieldChanged() => setState(() {});

  VisitDraft get _currentDraft => _draft.copyWith(
    visitorName: _nameController.text,
    visitorPhone: _phoneController.text,
    visitorEmail: _emailController.text,
    visitorCompany: _companyController.text,
  );

  void _continue() {
    final draft = _currentDraft;
    if (!draft.isStep1Complete) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterVisitStep2Screen(
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
                const VisitStepIndicator(currentStep: 1),
                const SizedBox(height: AppSpacing.xxl),
              ],
              Text('Visitor information', style: AppTypography.sectionTitle()),
              const SizedBox(height: 4),
              Text('Who is coming to visit?', style: AppTypography.authBody()),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Name',
                controller: _nameController,
                hintText: 'e.g. Sarah Ahmed',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Phone number',
                controller: _phoneController,
                hintText: '+966 55 000 0000',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                hintText: 'name@company.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Company',
                controller: _companyController,
                hintText: 'Company name',
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(
                label: 'Continue',
                onPressed: _currentDraft.isStep1Complete ? _continue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
