import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool borderless;

  const AppTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.borderless = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderSide = borderless
        ? const BorderSide(color: AppColors.transparent, width: 0)
        : const BorderSide(color: AppColors.gray300);

    return TextField(
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      style: AppTextStyles.body,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: AppSpacing.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12),
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
