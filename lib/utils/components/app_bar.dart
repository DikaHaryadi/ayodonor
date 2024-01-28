import 'package:flutter/material.dart';
import 'package:getdonor/utils/reusable_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.text,
    this.child,
    this.actions,
    required this.iconColor,
    required this.bgColor,
    this.fontFamily,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  final String? text;
  final Widget? child;
  final List<Widget>? actions;
  final Color iconColor;
  final Color bgColor;
  final String? fontFamily;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: iconColor),
      backgroundColor: bgColor,
      elevation: 0,
      automaticallyImplyLeading:
          automaticallyImplyLeading == true ? true : automaticallyImplyLeading,
      leadingWidth: 50,
      leading: child,
      actions: actions,
      centerTitle: centerTitle == true ? true : centerTitle,
      title: ReusableText(
        text: text ?? '',
        style: TextStyle(
            fontFamily: fontFamily ?? 'Poppins',
            fontSize: 16,
            color: iconColor,
            fontWeight: FontWeight.w300),
      ),
    );
  }
}
