import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/berita_indo_controller.dart';
import 'package:getdonor/controllers/font_size_controller.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';

import '../../controllers/themes_controller.dart';

class IsiBeritaIndo extends StatelessWidget {
  final int idBerita;
  const IsiBeritaIndo({Key? key, required this.idBerita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.height;

    var berita = Get.find<BeritaIndoController>().beritaIndoList[idBerita];
    final ThemeController themeController = Get.find();
    final ResponsiveTextController responsiveTextController =
        Get.put(ResponsiveTextController());

    double percentage = 80.0;
    int baseMaxLines = 4;

    int maxLines =
        responsiveTextController.calculateMaxLines(percentage, baseMaxLines);

    return Container(
      height: height * 0.45,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: NetworkImage(
            berita.img!.isNotEmpty
                ? ApiUtils.getImageUrl(berita.img!)
                : 'https://elements-video-cover-images-0.imgix.net/files/220512242/Preview.jpg?auto=compress&crop=edges&fit=crop&fm=jpeg&h=800&w=1200&s=3702b1eeb3ed39c89cbef83a0ec2e371',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(20.0),
              color: themeController.isDarkTheme()
                  ? Color(kDark.value).withOpacity(0.15)
                  : Color(kLight.value).withOpacity(0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: berita.title!,
                    maxlines: maxLines,
                    textAlign: TextAlign.left,
                    style: appstyle(
                      24,
                      themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kLight.withOpacity(0.8).value),
                      FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: themeController.isDarkTheme()
                          ? Color(kDarkGrey.value)
                          : Color(kDark.value).withOpacity(0.3),
                      child: ReusableText(
                        text: berita.typeBerita!,
                        style: appstyle(
                          14,
                          Color(kLight.value),
                          FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: themeController.isDarkTheme()
                    ? Color(kDark.value).withOpacity(0.5)
                    : Color(kLight.value).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    berita.deskripsi!,
                    textAlign: TextAlign.justify,
                    style: appstyle(
                      14,
                      themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kDark.value),
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
