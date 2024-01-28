import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/berita_indo_controller.dart';
import 'package:getdonor/controllers/rekomendasi_berita_controller.dart';
import 'package:getdonor/model/rekomendasi_model.dart';
import 'package:getdonor/pages/donasi.dart';
import 'package:getdonor/utils/components/berita_indo_found.dart';
import 'package:getdonor/utils/components/donasi_loading.dart';
import 'package:getdonor/utils/components/isi_rekomendasi.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:lottie/lottie.dart';

import '../controllers/themes_controller.dart';
import '../utils/Custom/app_bar.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/carousel_loading.dart';
import '../utils/components/isi_berita_indo.dart';

// ignore: must_be_immutable
class BeritaArtikel extends StatelessWidget {
  BeritaArtikel({
    Key? key,
  }) : super(key: key);
  BeritaIndoController beritaIndoController = Get.put(BeritaIndoController());
  ThemeController themeController = Get.put(ThemeController());
  BeritaRekomendasiController beritaRekomendasiController =
      Get.put(BeritaRekomendasiController());

  Future<void> refreshData() async {
    await Future.wait<void>([
      beritaIndoController.fetchData(),
      beritaRekomendasiController.fetchData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          bgColor: Theme.of(context).scaffoldBackgroundColor,
          iconColor: Color(kDarkicon.value),
          text: 'Berita',
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => Donasi());
              },
              child: Lottie.asset('images/animation_lktvemax.json',
                  width: width * 0.13, fit: BoxFit.cover),
            ),
          ],
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshData();
        },
        child: SafeArea(
            child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() => beritaIndoController.isLoading.value
                ? const CarouselLoading()
                : BeritaIndoFound(
                    beritaIndo: beritaIndoController.beritaIndoList,
                    onTap: _navigateToBerita,
                  )),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ReusableText(
                    text: 'Rekomendasi',
                    style: appstyle(
                        16,
                        themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kLightBlueContent.value),
                        FontWeight.bold)),
              ),
            ),
            Obx(
              () => beritaIndoController.isLoading.value
                  ? const DonasiLoading()
                  : ListView.builder(
                      itemCount: beritaRekomendasiController
                          .beritaRekomendasiList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        double width = Get.width;
                        double height = Get.height;
                        double imageWidth = width * 0.3;

                        RekomendasiModel rekomendasiModel =
                            beritaRekomendasiController
                                .beritaRekomendasiList[index];
                        String dateString = rekomendasiModel.tglDibuat!;
                        DateTime dateRekomendasi = DateTime.parse(dateString);
                        final theme = Theme.of(context);

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => IsiRekomendasi(idBerita: index));
                          },
                          child: Container(
                            width: width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: themeController.isDarkTheme()
                                    ? Color(kLightGrey.value)
                                    : Theme.of(context).scaffoldBackgroundColor,
                                border: Border.all(
                                    color: themeController.isDarkTheme()
                                        ? Color(kAksenDark.value)
                                        : Color(kLightGrey.value),
                                    width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Stack(
                              children: [
                                Container(
                                  height: height * 0.16,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  color: const Color.fromRGBO(0, 0, 0, 0),
                                ),
                                Positioned(
                                    top: height * 0.01,
                                    bottom: height * 0.01,
                                    right: width * 0.01,
                                    left: width * 0.01,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                                Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: width * 0.01,
                                    left: width * 0.35,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.01,
                                          horizontal: width * 0.01),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rekomendasiModel.title!,
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    fontSize: 14,
                                                    fontFamily: 'Epilogue',
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            rekomendasiModel.deskripsi!,
                                            maxLines: 3,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontFamily: 'Barlow',
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(
                                                            kAksenDark.value)
                                                        : Color(
                                                            kLightGrey.value),
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            children: [
                                              Text(
                                                rekomendasiModel.namaPembuat!,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontSize: 13,
                                                        fontFamily: 'Barlow',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: themeController
                                                                .isDarkTheme()
                                                            ? Color(kAksenDark
                                                                    .value)
                                                                .withOpacity(.9)
                                                            : Color(kLightGrey
                                                                    .value)
                                                                .withOpacity(
                                                                    .9)),
                                              ),
                                              Expanded(child: Container()),
                                              Text(
                                                beritaRekomendasiController
                                                    .formatTimeElapsed(
                                                        dateRekomendasi),
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        fontSize: 12,
                                                        fontFamily: 'Barlow',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themeController
                                                                .isDarkTheme()
                                                            ? Color(kAksenDark
                                                                    .value)
                                                                .withOpacity(.9)
                                                            : Color(kLightGrey
                                                                    .value)
                                                                .withOpacity(
                                                                    .9)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    top: height * 0.01,
                                    bottom: height * 0.01,
                                    left: width * 0.01,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        width: imageWidth,
                                        imageUrl: ApiUtils.getImageUrl(
                                            rekomendasiModel.img!),
                                        errorWidget: (_, url, error) =>
                                            Image.asset('images/error_img.jpg'),
                                        placeholder: (context, url) =>
                                            LottieBuilder.asset(
                                                'images/feedback_loading.json'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        )),
      ),
    );
  }

  void _navigateToBerita(int idBerita) {
    Get.to(() => IsiBeritaIndo(idBerita: idBerita));
  }
}
