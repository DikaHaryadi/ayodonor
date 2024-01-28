import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/reusable_text.dart';

import '../../controllers/themes_controller.dart';
import '../colors.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {Key? key,
      this.text,
      this.child,
      this.actions,
      required this.iconColor,
      required this.bgColor,
      this.centerTitle = true,
      this.automaticallyImplyLeading = true})
      : super(key: key);

  final String? text;
  final Widget? child;
  final List<Widget>? actions;
  final Color iconColor;
  final Color bgColor;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  ThemeController themeController = Get.put(ThemeController());

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
          style: appstyle(
              16,
              themeController.isDarkTheme()
                  ? Color(kLight.value)
                  : Color(kDark.value),
              FontWeight.w500)),
    );
  }
}
