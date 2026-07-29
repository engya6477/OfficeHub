import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Check your email')),
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
              Text('Instructions sent', style: AppTypography.heading().copyWith(fontSize: 22)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "We've sent password reset instructions to $email.",
                style: AppTypography.body(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Didn't receive it? Check your spam folder or try again.",
                style: AppTypography.cardMeta(),
              ),
              const Spacer(),
              AppButton(
                label: 'Try another email',
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Back to sign in',
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
