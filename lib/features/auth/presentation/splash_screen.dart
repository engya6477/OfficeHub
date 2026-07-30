import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), widget.onFinished);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: const AppIcon(
                  AppIcons.splashLogo,
                  size: 40,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('OfficeHub', style: AppTypography.heroTitle()),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your workplace, simplified',
                style: AppTypography.heroSubtitle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
