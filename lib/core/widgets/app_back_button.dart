import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'app_icon.dart';

/// AppBar back button using the exact chevron vector from Figma, instead of
/// Material's default arrow-with-shaft glyph.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const AppIcon(AppIcons.arrowLeft, color: AppColors.iconDark),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}
