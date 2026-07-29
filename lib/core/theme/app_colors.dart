import 'package:flutter/material.dart';

/// Color tokens extracted from the OfficeHub Figma file (design system + UI pages).
abstract final class AppColors {
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF3F4F6);
  static const Color borderStrong = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFDEDEDE);

  static const Color primary = Color(0xFF155DFC);
  static const Color primarySurface = Color(0xFFEFF6FF);
  static const Color visitorAccent = Color(0xFF9810FA);
  static const Color visitorAccentSurface = Color(0xFFFAF5FF);

  static const Color success = Color(0xFF007A55);
  static const Color successIcon = Color(0xFF00BC7D);
  static const Color successSurface = Color(0xFFEAFFE9);
  static const Color error = Color(0xFFCE3333);
  static const Color focus = Color(0xFF147E24);

  static const Color textPrimary = Color(0xFF0E0F0E);
  static const Color textPrimaryAlt = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color textMuted = Color(0xFF6A7282);
  static const Color textMutedAlt = Color(0xFF7A7E7B);
  static const Color textDisabled = Color(0xFF99A1AF);
  static const Color placeholder = Color(0xFFAEB4B0);

  static const Color chipBackground = Color(0xFFF3F4F6);
  static const Color disabledFieldBackground = Color(0xFFE2E6E3);

  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Diagonal brand-blue gradient used on the splash and sign-in hero.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
    stops: [0.0, 0.6, 1.0],
  );
}
