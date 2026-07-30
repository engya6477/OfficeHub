import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.onSignedUp});

  final VoidCallback onSignedUp;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _localError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthController auth) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _localError = 'Passwords do not match.');
      return;
    }
    setState(() => _localError = null);
    final success = await auth.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (success && mounted) widget.onSignedUp();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final errorMessage = _localError ?? auth.errorMessage;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Create account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill in your details to get started.',
                style: AppTypography.authBody(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Full Name',
                controller: _nameController,
                hintText: 'e.g. Sarah Ahmed',
                required: true,
                leadingIcon: Iconsax.user,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Work Email',
                controller: _emailController,
                hintText: 'name@company.com',
                required: true,
                leadingIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Company',
                controller: _companyController,
                hintText: 'Company name',
                required: true,
                leadingIcon: Iconsax.briefcase,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Password',
                controller: _passwordController,
                hintText: 'At least 6 characters',
                required: true,
                leadingIcon: Iconsax.lock,
                obscureText: _obscurePassword,
                trailingIcon: _obscurePassword
                    ? Iconsax.eye_slash
                    : Iconsax.eye,
                onTrailingIconPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Confirm password',
                controller: _confirmPasswordController,
                hintText: 'Repeat your password',
                required: true,
                leadingIcon: Iconsax.lock,
                obscureText: _obscureConfirm,
                trailingIcon: _obscureConfirm ? Iconsax.eye_slash : Iconsax.eye,
                onTrailingIconPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  errorMessage,
                  style: AppTypography.cardMeta(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Create account',
                loading: auth.isLoading,
                onPressed: () => _submit(auth),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.authBody(),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text('Sign in', style: AppTypography.authLink()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
