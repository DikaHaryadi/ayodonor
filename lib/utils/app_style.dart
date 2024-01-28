import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/font_size_controller.dart';

TextStyle appstyle(
  double size,
  Color? color,
  FontWeight fw,
) {
  final ResponsiveTextController controller =
      Get.put(ResponsiveTextController());
  double responsiveFontSize = controller.calculateResponsiveFontSize(
      size, MediaQuery.of(Get.context!).size.width, size // Get screen width
      );

  return TextStyle(
      fontSize: responsiveFontSize,
      color: color,
      fontWeight: fw,
      height: 1.4,
      fontFamily: 'Epilogue');
}
