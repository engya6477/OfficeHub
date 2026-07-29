import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/auth_controller.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthController auth) async {
    final success = await auth.signIn(email: _emailController.text, password: _passwordController.text);
    if (success && mounted) widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.xl)),
                    child: const Icon(Iconsax.lock, color: AppColors.primary, size: 26),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Welcome back', style: AppTypography.heroTitle()),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Sign in to your OfficeHub account', style: AppTypography.heroSubtitle()),
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
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'At least 6 characters',
                    required: true,
                    leadingIcon: Iconsax.lock,
                    obscureText: _obscure,
                    trailingIcon: _obscure ? Iconsax.eye : Iconsax.eye_slash,
                    onTrailingIconPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      ),
                      child: Text('Forgot password?', style: AppTypography.linkMedium()),
                    ),
                  ),
                  if (auth.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(auth.errorMessage!, style: AppTypography.cardMeta(color: AppColors.error)),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(label: 'Sign in', loading: auth.isLoading, onPressed: () => _submit(auth)),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Don't have an account? ", style: AppTypography.authBody()),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SignUpScreen(onSignedUp: () => Navigator.of(context).pop()),
                            ),
                          ),
                          child: Text('Sign up', style: AppTypography.authLink()),
                        ),
                      ],
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
