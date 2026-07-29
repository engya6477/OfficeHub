import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/auth_controller.dart';
import 'check_email_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthController auth) async {
    final success = await auth.sendPasswordReset(email: _emailController.text);
    if (success && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CheckEmailScreen(email: _emailController.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forgot your password?', style: AppTypography.heading().copyWith(fontSize: 22)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Enter your work email and we'll send you instructions to reset your password.",
                style: AppTypography.body(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Work Email',
                controller: _emailController,
                hintText: 'name@company.com',
                required: true,
                leadingIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(auth.errorMessage!, style: AppTypography.cardMeta(color: AppColors.error)),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Send reset instructions', loading: auth.isLoading, onPressed: () => _submit(auth)),
            ],
          ),
        ),
      ),
    );
  }
}
