import 'package:flutter/material.dart';
import 'package:muipzi/constants/assets.dart';
import 'package:muipzi/theme/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final bool autofocus;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _unfocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              color: _hasFocus ? AppColors.gray700 : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: _hasFocus ? AppColors.gray900 : AppColors.gray500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                onSubmitted: (_) => widget.onSubmitted?.call(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                enableSuggestions: true,
                enableIMEPersonalizedLearning: true,
                style: const TextStyle(
                  color: AppColors.gray900,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? '날씨를 가져오고 싶은 도시를 입력하세요',
                  hintStyle: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  suffixIcon:
                      _hasText && _hasFocus
                          ? GestureDetector(
                            onTap: _clearText,
                            child: AppAssets.clearTextIcon,
                          )
                          : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
