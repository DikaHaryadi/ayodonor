import 'package:get/get.dart';

class ResponsiveTextController extends GetxController {
  double calculateResponsiveFontSize(
      double targetFontSize, double percentage, double minFontSize) {
    double screenWidth = Get.width;
    double baseWidth = screenWidth * (percentage / 100);
    double scaleFactor = screenWidth / baseWidth;

    double scaledFontSize = targetFontSize * scaleFactor;

    return scaledFontSize < minFontSize ? minFontSize : scaledFontSize;
  }

  int calculateMaxLines(double percentage, int baseMaxLines) {
    double screenWidth = Get.width;
    double baseWidth = screenWidth * (percentage / 100);
    double scaleFactor = screenWidth / baseWidth;

    int scaledMaxLines = (baseMaxLines * scaleFactor).toInt();

    return scaledMaxLines < 1 ? 1 : scaledMaxLines;
  }
}
