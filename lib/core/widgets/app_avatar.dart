import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Circular initials avatar (Figma "Avatar" component).
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.initial, this.size = 36});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(initial, style: AppTypography.avatarInitial()),
    );
  }
}
