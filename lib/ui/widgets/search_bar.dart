import 'package:flutter/material.dart';

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
        ? const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          )
        : BorderRadius.circular(28);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: _isFocused ? Colors.teal : Colors.grey[300]!,
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
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.location_on,
              color: _isFocused ? Colors.teal : Colors.grey[600],
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 48,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.search,
              color: _isFocused ? Colors.teal : Colors.grey[400],
              size: 22,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 48,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 8,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Colors.teal,
        cursorWidth: 2,
      ),
    );
  }
}
