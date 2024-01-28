import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/table_darah_controller.dart';
import 'package:getdonor/controllers/utama_berita_controller.dart';
import 'package:getdonor/pages/blood_info.dart';
import 'package:getdonor/pages/donasi.dart';
import 'package:getdonor/pages/info_profile.dart';
import 'package:getdonor/pages/jadwal_donor.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/utils/components/carousel_loading.dart';
import 'package:getdonor/utils/components/carousel_slider_found.dart';
import 'package:getdonor/utils/components/isi_berita_utama.dart';
import 'package:getdonor/utils/components/table_darah.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../controllers/fb_controller.dart';
import '../controllers/font_size_controller.dart';
import '../controllers/histori_donor_controller.dart';
import '../controllers/themes_controller.dart';
import '../model/histori_model.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/kartu_donor.dart';
import '../utils/components/storage_util.dart';
import '../utils/reusable_text.dart';
import 'info_pertolongan_pertama.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  BeritaUtamaController beritaUtamaController =
      Get.put(BeritaUtamaController());

  final TableController tableController = Get.put(TableController());
  final FacebookAuthController facebookAuthController =
      Get.put(FacebookAuthController());
  HistoriDonorController historiDonorController =
      Get.put(HistoriDonorController());
  final ResponsiveTextController responsiveTextController =
      Get.put(ResponsiveTextController());

  final themeController = Get.find<ThemeController>();

  final StorageUtil storage = StorageUtil();

  final int maxBackPressCount = 2;
  int currentIndex = 0;
  double percentage = 80.0;
  int baseMaxLines = 4;

  final RxInt backPressCount = 0.obs;

  Future<void> refreshData() async {
    await Future.wait<void>([
      beritaUtamaController.fetchData(),
      tableController.getMaster(),
      historiDonorController.fetchData(storage.getNik())
      // facebookAuthController.checkIfIsLoggedIn(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    int maxLines =
        responsiveTextController.calculateMaxLines(percentage, baseMaxLines);
    var width = Get.width;

    return WillPopScope(
        onWillPop: () async {
          if (backPressCount.value == maxBackPressCount) {
            return true;
          } else {
            Get.snackbar(
              "Keluar :",
              "Klik 2x untuk keluar aplikasi",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
            backPressCount.value++;
            Future.delayed(const Duration(seconds: 2), () {
              backPressCount.value = 0;
            });
            return false;
          }
        },
        child: Scaffold(
            body: SafeArea(
                child: RefreshIndicator(
                    onRefresh: () async {
                      await refreshData();
                    },
                    child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Row(children: [
                            Image.asset(
                              'images/logo.png',
                              width: width * 0.12,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            GetBuilder<ThemeController>(
                                init: themeController,
                                builder: (controller) {
                                  return ReusableText(
                                      text: 'Palang Merah\nIndonesia',
                                      style: appstyle(
                                          16,
                                          themeController.isDarkTheme()
                                              ? Color(kLight.value)
                                              : Color(kLightGrey.value),
                                          FontWeight.w600));
                                }),
                            Expanded(child: Container()),
                            GetBuilder<ThemeController>(
                                init: themeController,
                                builder: (controller) {
                                  return IconButton(
                                    onPressed: () {
                                      bool isDarkMode =
                                          !controller.isDarkTheme();
                                      controller.changeThemeMode(isDarkMode
                                          ? ThemeMode.dark
                                          : ThemeMode.light);
                                      controller.saveTheme(isDarkMode);
                                    },
                                    icon: controller.isDarkTheme()
                                        ? const Icon(
                                            Ionicons.cloudy_night_outline)
                                        : const Icon(
                                            Ionicons.partly_sunny_outline),
                                  );
                                })
                          ]),
                          const SizedBox(height: 10),
                          GetBuilder<ThemeController>(
                              init: themeController,
                              builder: (controller) {
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            storage.getEmail() == ''
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              const Login());
                                                        },
                                                        child: ReusableText(
                                                            text: 'Guest',
                                                            style: appstyle(
                                                                20,
                                                                themeController
                                                                        .isDarkTheme()
                                                                    ? Color(
                                                                        kLight
                                                                            .value)
                                                                    : Color(kLightGrey
                                                                        .value),
                                                                FontWeight
                                                                    .w600))))
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              const InfoProfile());
                                                        },
                                                        child: ReusableText(
                                                            text: storage
                                                                .getName(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16,
                                                                color: themeController
                                                                        .isDarkTheme()
                                                                    ? Color(kLight
                                                                        .value)
                                                                    : Color(kLightGrey.value),
                                                                fontWeight: FontWeight.w600)))),
                                            Row(children: [
                                              storage.getPhone() == ''
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              const Login());
                                                        },
                                                        child: ReusableText(
                                                            text:
                                                                'Silahkan login terlebih dahulu',
                                                            style: appstyle(
                                                                12,
                                                                themeController
                                                                        .isDarkTheme()
                                                                    ? Color(kLight
                                                                        .value)
                                                                    : Color(kLightGrey
                                                                        .value),
                                                                FontWeight
                                                                    .w400)),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: ReusableText(
                                                          text: storage.getGolDarah() ==
                                                                      'N/A' ||
                                                                  storage.getRhesus() ==
                                                                      'N/A'
                                                              ? 'Golongan Darah (${storage.getGolDarah()} | ${storage.getRhesus()})'
                                                              : 'Golongan Darah (${storage.getGolDarah()}${storage.getRhesus()})',
                                                          style: appstyle(
                                                              12,
                                                              themeController
                                                                      .isDarkTheme()
                                                                  ? Color(kLight
                                                                      .value)
                                                                  : Color(
                                                                      kLightGrey
                                                                          .value),
                                                              FontWeight
                                                                  .w400))),
                                              storage.getPhone() == ''
                                                  ? const Text('')
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: SelectableText(
                                                          '| ${storage.getPhone()}',
                                                          style: appstyle(
                                                              12,
                                                              themeController
                                                                      .isDarkTheme()
                                                                  ? Color(kLight
                                                                      .value)
                                                                  : Color(
                                                                      kLightGrey
                                                                          .value),
                                                              FontWeight.w400)))
                                            ])
                                          ]),
                                      storage.getLogin() == 'False'
                                          ? InkWell(
                                              onTap: () {
                                                Get.to(() => Donasi());
                                              },
                                              child: Lottie.asset(
                                                  'images/animation_lktvemax.json',
                                                  width: width * 0.13,
                                                  fit: BoxFit.cover))
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    _showKartu(context);
                                                  },
                                                  child: Lottie.asset(
                                                      'images/card.json',
                                                      width: width * 0.12)))
                                    ]);
                              }),
                          Obx(() => beritaUtamaController.isLoading.value
                              ? const CarouselLoading()
                              : CarouselSliderDataFound(
                                  carouselList:
                                      beritaUtamaController.beritaUtamaList,
                                  onTap: _navigateToBerita,
                                )),
                          storage.getLogin() == 'False'
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ReusableText(
                                            text: 'Ketersediaan Darah',
                                            style: appstyle(
                                                16, null, FontWeight.bold)),
                                        InkWell(
                                            onTap: () {
                                              Get.to(() =>
                                                  const InfoPertolonganPertama());
                                            },
                                            child: const ReusableText(
                                                text: 'Info Lain',
                                                style: TextStyle(
                                                    color: Color(0xFF98A8F8),
                                                    fontFamily: 'Epilogue',
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 13)))
                                      ]))
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10, bottom: 10),
                                  child: ReusableText(
                                      text: 'Jadwal Pendonoran Darah',
                                      style:
                                          appstyle(16, null, FontWeight.bold))),
                          storage.getLogin() == 'False'
                              ? const TableDarah()
                              : const JadwalDonor(),
                          storage.getLogin() == 'False'
                              ? const SizedBox.shrink()
                              : Container(
                                  color: Colors.transparent,
                                  child: Column(children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 10, right: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ReusableText(
                                                  text: 'Riwayat Pendonoran',
                                                  style: appstyle(16, null,
                                                      FontWeight.bold)),
                                              InkWell(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        BloodInformation(
                                                            nik: storage
                                                                .getNik()));
                                                  },
                                                  child: const ReusableText(
                                                      text: 'Blood info',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 13,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight
                                                              .normal)))
                                            ])),
                                    Obx(() {
                                      if (historiDonorController
                                          .isLoading.value) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (currentIndex <
                                          historiDonorController
                                              .historiList.length) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: historiDonorController
                                                .historiList.length,
                                            itemBuilder: (context, index) {
                                              HistoriModel historiModel =
                                                  historiDonorController
                                                      .historiList[index];
                                              return GetBuilder<
                                                      ThemeController>(
                                                  init: themeController,
                                                  builder: (controller) {
                                                    return Container(
                                                        width: Get.width,
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8),
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                        decoration: BoxDecoration(
                                                            color: themeController
                                                                    .isDarkTheme()
                                                                ? Color(
                                                                    kLightGrey
                                                                        .value)
                                                                : Color(kLight
                                                                    .value),
                                                            border: Border.all(
                                                                color: themeController
                                                                        .isDarkTheme()
                                                                    ? Color(kAksenDark.value)
                                                                    : Color(kLightGrey.value),
                                                                width: .8)),
                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          ReusableText(
                                                            text: historiModel
                                                                .namaInstansi!,
                                                            style: appstyle(
                                                                14,
                                                                null,
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          ReusableText(
                                                              text: historiModel
                                                                  .lokasi!,
                                                              maxlines:
                                                                  maxLines,
                                                              style: appstyle(
                                                                  14,
                                                                  null,
                                                                  FontWeight
                                                                      .normal)),
                                                          RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'Tanggal daftar : ',
                                                                  style: appstyle(
                                                                      13,
                                                                      themeController
                                                                              .isDarkTheme()
                                                                          ? Color(kLight
                                                                              .value)
                                                                          : Color(kDark
                                                                              .value),
                                                                      FontWeight
                                                                          .normal),
                                                                  children: <TextSpan>[
                                                                TextSpan(
                                                                    text: historiDonorController
                                                                        .dateTime
                                                                        .format(DateTime.parse(historiModel
                                                                            .tgldaftar!)),
                                                                    style: appstyle(
                                                                        13,
                                                                        themeController.isDarkTheme()
                                                                            ? Color(kLight
                                                                                .value)
                                                                            : Color(kDark
                                                                                .value),
                                                                        FontWeight
                                                                            .normal))
                                                              ])),
                                                          RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'Tanggal donor : ',
                                                                  style: appstyle(
                                                                      13,
                                                                      themeController
                                                                              .isDarkTheme()
                                                                          ? Color(kLight
                                                                              .value)
                                                                          : Color(kDark
                                                                              .value),
                                                                      FontWeight
                                                                          .normal),
                                                                  children: <TextSpan>[
                                                                TextSpan(
                                                                    text: historiDonorController
                                                                        .dateTime
                                                                        .format(DateTime.parse(historiModel
                                                                            .tgldonor!)),
                                                                    style: appstyle(
                                                                        13,
                                                                        themeController.isDarkTheme()
                                                                            ? Color(kLight
                                                                                .value)
                                                                            : Color(kDark
                                                                                .value),
                                                                        FontWeight
                                                                            .normal))
                                                              ]))
                                                        ]));
                                                  });
                                            });
                                      } else {
                                        return GetBuilder<ThemeController>(
                                            init: themeController,
                                            builder: (controller) {
                                              return Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10),
                                                  child: Center(
                                                      child: Container(
                                                          width: Get.width,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8),
                                                          margin: const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: themeController
                                                                      .isDarkTheme()
                                                                  ? Color(kLightGrey
                                                                      .value)
                                                                  : Color(kLight
                                                                      .value),
                                                              border: Border.all(
                                                                  color: themeController.isDarkTheme()
                                                                      ? Color(kAksenDark.value)
                                                                      : Color(kLightGrey.value),
                                                                  width: .8)),
                                                          child: ReusableText(text: 'Anda Belum Pernah Melakukan\nPendonoran Darah', textAlign: TextAlign.center, style: appstyle(16, null, FontWeight.w700)))));
                                            });
                                      }
                                    })
                                  ]))
                        ])))));
  }

  void _navigateToBerita(int idBerita) {
    Get.to(() => IsiBeritaUtama(idBerita: idBerita));
  }

  _showKartu(BuildContext context) {
    return showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Kartu Donor",
        context: context,
        transitionDuration: const Duration(milliseconds: 400),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          Tween<Offset> tween;
          tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
          return SlideTransition(
            position: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
        pageBuilder: (context, _, __) => Center(
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: const Scaffold(body: KartuDonor()))));
  }
}
