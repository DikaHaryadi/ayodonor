import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/utils/reusable_text.dart';

import '../app_style.dart';
import '../colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    required this.hintText,
    required this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.obscureText,
    this.readOnly,
    this.suffixIcon,
    this.focusNode,
    this.prefixIcon,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool? readOnly;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  final ThemeController themeController = Get.put(ThemeController());

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      return;
    }

    if (mounted) {
      Future.microtask(() {
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeController.isDarkTheme()
          ? Color(kAksenDark.value)
          : const Color(0x97BCBABA),
      child: TextFormField(
        maxLength: widget.maxLength,
        maxLines: widget.maxLines == 0 ? null : widget.maxLines,
        minLines: 1,
        obscureText: widget.obscureText ?? false,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            label: ReusableText(
              text: widget.hintText,
              style: TextStyle(
                  fontSize: 14,
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.bold),
            ),
            suffixIcon: widget.suffixIcon,
            hintStyle: appstyle(
                14,
                themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kDark.value),
                FontWeight.w500),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.red, width: 0.5)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.transparent, width: 0)),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.red, width: 0.5)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide:
                    BorderSide(color: Color(kDarkGrey.value), width: 0.5)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.transparent, width: 0.5)),
            border: InputBorder.none),
        controller: widget.controller,
        cursorHeight: 25,
        style: appstyle(
            14,
            themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDark.value),
            FontWeight.w500),
        focusNode: _focusNode,
      ),
    );
  }
}
