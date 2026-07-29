import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import 'main_shell.dart';

/// Top-level state machine: splash -> onboarding -> sign in -> main shell.
/// Kept as a simple widget swap (rather than a router) since this flow is
/// linear and not deep-linkable.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _showSplash = true;
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (_showSplash) {
      return SplashScreen(onFinished: () => setState(() => _showSplash = false));
    }
    if (!_onboardingDone) {
      return OnboardingScreen(onFinished: () => setState(() => _onboardingDone = true));
    }
    if (!auth.isAuthenticated) {
      return SignInScreen(onSignedIn: () {});
    }
    return const MainShell();
  }
}
