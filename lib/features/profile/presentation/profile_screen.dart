import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      Text(
                        'Profile',
                        style: AppTypography.heroSubtitle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Text(
                      employee.initial,
                      style: AppTypography.avatarInitial(
                        color: AppColors.primary,
                      ).copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(employee.name, style: AppTypography.heroTitle()),
                  const SizedBox(height: AppSpacing.xs),
                  Text(employee.jobTitle, style: AppTypography.heroSubtitle()),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Column(
                      children: [
                        _ProfileRow(
                          icon: Iconsax.user,
                          label: 'Name',
                          value: employee.name,
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.border,
                          indent: AppSpacing.lg,
                          endIndent: AppSpacing.lg,
                        ),
                        _ProfileRow(
                          icon: Iconsax.briefcase,
                          label: 'Company',
                          value: employee.company,
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.border,
                          indent: AppSpacing.lg,
                          endIndent: AppSpacing.lg,
                        ),
                        _ProfileRow(
                          icon: Iconsax.sms,
                          label: 'Email',
                          value: employee.email,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                        Text(
                          'About',
                          style: AppTypography.cardMeta(
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('OfficeHub', style: AppTypography.listTitle()),
                        const SizedBox(height: 2),
                        Text(
                          'Version 1.0.0 · Nova Building',
                          style: AppTypography.cardMeta(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    label: 'Sign out',
                    variant: AppButtonVariant.destructive,
                    icon: Iconsax.logout,
                    onPressed: () => _signOut(context),
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

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, size: 18, color: AppColors.textMuted),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.cardMeta(color: AppColors.textDisabled),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.listTitle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
