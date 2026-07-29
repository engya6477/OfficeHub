import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Text field matching the Figma "Input" component: label with required dot,
/// leading/trailing icon slots, and an optional helper/error message.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.required = false,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.helperText,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool required;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? helperText;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.inputLabel()),
            if (required) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTypography.body(),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            helperText: errorText == null ? helperText : null,
            helperStyle: AppTypography.helper(color: AppColors.textMutedAlt),
            prefixIcon: leadingIcon != null
                ? Icon(leadingIcon, size: 24, color: AppColors.textMutedAlt)
                : null,
            suffixIcon: trailingIcon != null
                ? IconButton(
                    icon: Icon(
                      trailingIcon,
                      size: 24,
                      color: AppColors.textMutedAlt,
                    ),
                    onPressed: onTrailingIconPressed,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
