import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChanged;
  final bool removeBottomRadius;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.onFocusChanged,
    this.removeBottomRadius = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      widget.onFocusChanged?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.removeBottomRadius
        ? BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.r28),
            topRight: Radius.circular(AppSpacing.r28),
          )
        : BorderRadius.circular(AppSpacing.r28);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.gray300,
          width: 1.5,
        ),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.gray400,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Padding(
            padding: AppSpacing.only(left: AppSpacing.s12),
            child: Icon(
              Icons.location_on,
              color: _isFocused ? AppColors.primary : AppColors.gray600,
              size: AppSpacing.s22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: AppSpacing.s40,
            minHeight: AppSpacing.s48,
          ),
          suffixIcon: Padding(
            padding: AppSpacing.only(right: AppSpacing.s12),
            child: Icon(
              Icons.search,
              color: _isFocused ? AppColors.primary : AppColors.gray400,
              size: AppSpacing.s22,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: AppSpacing.s40,
            minHeight: AppSpacing.s48,
          ),
          contentPadding: AppSpacing.symmetric(
            vertical: AppSpacing.s14,
            horizontal: AppSpacing.sm,
          ),
        ),
        style: AppTextStyles.body.copyWith(
          color: AppColors.gray900,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.primary,
        cursorWidth: 2,
      ),
    );
  }
}
