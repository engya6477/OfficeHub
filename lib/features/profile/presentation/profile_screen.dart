import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/mock/mock_seed.dart';
import '../../auth/application/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _signOut(BuildContext context) {
    context.read<AuthController>().signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final employee = MockSeed.currentEmployee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text(
                  employee.initial,
                  style: AppTypography.heading(color: AppColors.onPrimary).copyWith(fontSize: 32),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(employee.name, style: AppTypography.heading().copyWith(fontSize: 20)),
              const SizedBox(height: 2),
              Text(employee.jobTitle, style: AppTypography.cardMeta(color: AppColors.textMuted)),
              const SizedBox(height: AppSpacing.xxxl),
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
                    Text('About', style: AppTypography.sectionTitle()),
                    const SizedBox(height: AppSpacing.sm),
                    Text('OfficeHub', style: AppTypography.listTitle()),
                    const SizedBox(height: 2),
                    Text('Version 1.0.0 · ${employee.company.replaceFirst('Nova Company', 'Nova Building')}',
                        style: AppTypography.cardMeta()),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Sign out',
                variant: AppButtonVariant.outline,
                onPressed: () => _signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
