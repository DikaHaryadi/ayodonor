import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/font_size_controller.dart';
import 'package:getdonor/controllers/utama_berita_controller.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:intl/intl.dart';

import '../../controllers/themes_controller.dart';

class IsiBeritaUtama extends StatelessWidget {
  final int idBerita;
  IsiBeritaUtama({Key? key, required this.idBerita}) : super(key: key);

  final dateTime = DateFormat("EEE, d/M/y", 'id_ID');

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.height;

    var berita = Get.find<BeritaUtamaController>().beritaUtamaList[idBerita];
    final ThemeController themeController = Get.find();
    final ResponsiveTextController responsiveTextController =
        Get.put(ResponsiveTextController());

    double percentage = 80.0; // Base width percentage
    int baseMaxLines = 10; // Base max lines

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
        body: ListView(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(20.0),
              color: themeController.isDarkTheme()
                  ? Color(kLight.value).withOpacity(0.05)
                  : Color(kDark.value).withOpacity(0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: berita.title!,
                    maxlines: maxLines,
                    textAlign: TextAlign.left,
                    style: appstyle(
                      24,
                      Color(kLight.value),
                      FontWeight.bold,
                    ),
                  ),
                  ReusableText(
                    text: berita.subtitle!,
                    maxlines: maxLines,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(kLight.value),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Barlow'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      dateTime.format(DateTime.parse(berita.tanggal!)),
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(kLight.value),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Barlow'),
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
                    : Color(kLight.value).withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    berita.deskripsi!,
                    textAlign: TextAlign.left,
                    style: appstyle(
                      14,
                      themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kDark.value),
                      FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: 'Pembuat : ',
                        style: appstyle(
                            14,
                            themeController.isDarkTheme()
                                ? Color(kLight.value)
                                : Color(kDark.value),
                            FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                              text: berita.namaPembuat!,
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
