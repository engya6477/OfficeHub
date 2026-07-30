import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text styles matching the two typefaces used across the Figma file:
/// Outfit for headings/labels/body copy, Inter for card and list content.
/// Both are bundled as local variable-font assets (see pubspec.yaml).
abstract final class AppTypography {
  static TextStyle _outfit(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
  }) => TextStyle(
    fontFamily: 'Outfit',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  static TextStyle _inter(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
  }) => TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  // Screen / app bar title, e.g. "Search", "Filters".
  static TextStyle screenTitle({Color color = AppColors.textPrimary}) =>
      _outfit(18, FontWeight.w400, color);

  // Section headers, e.g. "What would you like to do?", "Today", "Recent Search".
  static TextStyle sectionTitle({Color color = AppColors.textPrimary}) =>
      _outfit(18, FontWeight.w500, color);

  // Greeting / emphasis heading, e.g. "Welcome , Ahmed".
  static TextStyle heading({Color color = AppColors.textPrimary}) =>
      _outfit(18, FontWeight.w600, color);

  static TextStyle inputLabel({Color color = AppColors.textMutedAlt}) =>
      _outfit(16, FontWeight.w500, color);

  static TextStyle body({Color color = AppColors.textPrimary}) =>
      _outfit(16, FontWeight.w400, color);

  static TextStyle bodyPlaceholder({Color color = AppColors.placeholder}) =>
      _outfit(16, FontWeight.w400, color);

  static TextStyle chipLabel({Color color = AppColors.textPrimary}) =>
      _outfit(14, FontWeight.w400, color);

  static TextStyle caption({Color color = AppColors.textMutedAlt}) =>
      _outfit(12, FontWeight.w400, color);

  // Register Visit step progress label ("Step 1 of 2").
  static TextStyle stepLabel({Color color = AppColors.textDisabled}) =>
      _inter(12, FontWeight.w500, color);

  static TextStyle helper({Color color = AppColors.textPrimary}) =>
      _outfit(12, FontWeight.w400, color);

  static TextStyle buttonLabel({Color color = AppColors.onPrimary}) =>
      _outfit(18, FontWeight.w500, color);

  // Splash / auth-hero heading and subtitle, set in Inter (not Outfit).
  static TextStyle heroTitle({Color color = AppColors.onPrimary}) =>
      _inter(26, FontWeight.w700, color, height: 1.2);

  static TextStyle heroSubtitle({Color color = AppColors.onPrimary}) =>
      _inter(14, FontWeight.w400, color, height: 1.5);

  // Onboarding slide heading/message.
  static TextStyle onboardingTitle({Color color = Colors.black}) =>
      _outfit(24, FontWeight.w600, color, height: 40 / 24);

  static TextStyle onboardingMessage({Color color = AppColors.textMutedAlt}) =>
      _outfit(16, FontWeight.w400, color);

  // Auth screen helper copy ("Fill in your details...", "Don't have an account?").
  static TextStyle authBody({Color color = AppColors.textMuted}) =>
      _inter(14, FontWeight.w400, color, height: 1.5);

  // Auth screen inline links ("Sign in" / "Sign up").
  static TextStyle authLink({Color color = AppColors.primary}) =>
      _inter(16, FontWeight.w600, color);

  // "Forgot password?" style link.
  static TextStyle linkMedium({Color color = AppColors.primary}) =>
      _inter(14, FontWeight.w500, color);

  // Full-page feedback/confirmation screens ("You're all set!").
  static TextStyle feedbackTitle({Color color = AppColors.textPrimaryAlt}) =>
      _inter(20, FontWeight.w700, color, height: 28 / 20);

  static TextStyle feedbackMessage({Color color = AppColors.textMuted}) =>
      _inter(14, FontWeight.w400, color, height: 22.75 / 14);

  // Card / list content set in Inter.
  static TextStyle cardTitle({Color color = AppColors.textPrimary}) =>
      _inter(15, FontWeight.w600, color, height: 1.5);

  static TextStyle listTitle({Color color = AppColors.textPrimaryAlt}) =>
      _inter(14, FontWeight.w600, color);

  static TextStyle cardMeta({Color color = AppColors.textDisabled}) =>
      _inter(12, FontWeight.w500, color, height: 1.5);

  static TextStyle navLabel({Color color = AppColors.textDisabled}) =>
      _inter(12, FontWeight.w500, color);

  static TextStyle stepperValue({Color color = AppColors.textPrimaryAlt}) =>
      _inter(16, FontWeight.w600, color);

  static TextStyle avatarInitial({Color color = AppColors.onPrimary}) =>
      _inter(14, FontWeight.w600, color);

  static TextStyle link({Color color = AppColors.primary}) =>
      _inter(12, FontWeight.w600, color);

  // Booking/visit history status pill ("Upcoming" / "Past" / "Cancelled").
  static TextStyle statusBadge({required Color color}) => _inter(
    12,
    FontWeight.w600,
    color,
    height: 16 / 12,
  ).copyWith(letterSpacing: 0.3);

  // History card date/time row ("Mon, Jul 20 · 9:00 AM").
  static TextStyle historyRow({Color color = AppColors.textSecondary}) =>
      _inter(14, FontWeight.w500, color, height: 20 / 14);

  // History card dot separator and meta row ("3 attendees · 1 hr").
  static TextStyle historyMeta({Color color = AppColors.textDisabled}) =>
      _inter(12, FontWeight.w500, color, height: 16 / 12);
}
