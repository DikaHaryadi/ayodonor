import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/aftap_controller.dart';
import 'package:getdonor/model/pemeriksaan_model.dart';
import 'package:getdonor/pages/aftap_pendonor.dart';
import 'package:getdonor/pages/info_profile.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/check_nik_controller.dart';
import '../controllers/themes_controller.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/donasi_loading.dart';
import '../utils/reusable_text.dart';

enum _Tab {
  all,
  done,
  cancel,
}

class AftapRootPage extends StatefulWidget {
  const AftapRootPage({super.key});

  @override
  State<AftapRootPage> createState() => _AftapRootPageState();
}

class _AftapRootPageState extends State<AftapRootPage> {
  late ThemeController themeController;
  CheckNikController checkNikController = Get.put(CheckNikController());
  AftapController aftapController = Get.put(AftapController());

  final StorageUtil storage = StorageUtil();
  var width = Get.width;

  final RxInt backPressCount = 0.obs;
  final int maxBackPressCount = 2;
  final selectedTab = ValueNotifier(_Tab.all);

  void initializeData() {
    aftapController.fetchDataPemeriksaan(storage.getInstansiBekerja(), '1');
    aftapController.fetchDataPemeriksaanDitolak(storage.getInstansiBekerja());
    aftapController.fetchDataPemeriksaanDiterima(storage.getInstansiBekerja());
  }

  @override
  void initState() {
    themeController = Get.find<ThemeController>();
    initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StorageUtil storage = StorageUtil();
    return Scaffold(
      body: WillPopScope(
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
        child: RefreshIndicator(
          onRefresh: () async {
            initializeData();
          },
          child: ListView(
            children: [
              Row(
                children: [
                  Image.asset(
                    'images/logo.png',
                    width: width * 0.12,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  GetBuilder(
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
                    },
                  ),
                  Expanded(child: Container()),
                  GetBuilder<ThemeController>(
                    init: themeController,
                    builder: (controller) {
                      return IconButton(
                        onPressed: () {
                          bool isDarkMode = !controller.isDarkTheme();
                          controller.changeThemeMode(
                              isDarkMode ? ThemeMode.dark : ThemeMode.light);
                          controller.saveTheme(isDarkMode);
                        },
                        icon: controller.isDarkTheme()
                            ? const Icon(Ionicons.cloudy_night_outline)
                            : const Icon(Ionicons.partly_sunny_outline),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              GetBuilder<ThemeController>(
                init: themeController,
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5.0,
                                    offset: const Offset(0, 5),
                                    color: themeController.isDarkTheme()
                                        ? Color(kAksenDark.value)
                                            .withOpacity(.3)
                                        : const Color(0xFFe8e8e8)),
                                BoxShadow(
                                  offset: const Offset(-5, 0),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                BoxShadow(
                                  offset: const Offset(5, 0),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                )
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      storage.getNameAFTAP() == ''
                                          ? const SizedBox.shrink()
                                          : ReusableText(
                                              text: storage.getNameAFTAP(),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: themeController
                                                          .isDarkTheme()
                                                      ? Color(kLight.value)
                                                      : Color(kLightGrey.value),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                      storage.getPhone() == ''
                                          ? const Text('')
                                          : SelectableText(
                                              'Nomer Telepon | ${storage.getPhone()}',
                                              style: appstyle(
                                                  12,
                                                  themeController.isDarkTheme()
                                                      ? Color(kLight.value)
                                                      : Color(kLightGrey.value),
                                                  FontWeight.w400)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => const InfoProfile());
                                    },
                                    child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            ApiUtils.getAftapImageUrl(
                                                storage.getImg()))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.all;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color: themeController
                                                      .isDarkTheme()
                                                  ? value == _Tab.all
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kAksenDark.value)
                                                  : value == _Tab.all
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kLight.value),
                                              border: Border.all(
                                                  color: themeController
                                                          .isDarkTheme()
                                                      ? Color(kLight.value)
                                                      : Color(
                                                          kAksenDark.value))),
                                          child: Text(
                                            'Semua',
                                            style: TextStyle(
                                                fontFamily: 'Epilogue',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: value == _Tab.all
                                                    ? Colors.white
                                                    : themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.cancel;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: themeController
                                                      .isDarkTheme()
                                                  ? value == _Tab.cancel
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kAksenDark.value)
                                                  : value == _Tab.cancel
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kLight.value),
                                              border: Border.all(
                                                  color: themeController
                                                          .isDarkTheme()
                                                      ? Color(kLight.value)
                                                      : Color(
                                                          kAksenDark.value))),
                                          child: Text(
                                            'Ditolak',
                                            style: TextStyle(
                                                fontFamily: 'Epilogue',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: value == _Tab.cancel
                                                    ? Colors.white
                                                    : themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.done;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: themeController
                                                      .isDarkTheme()
                                                  ? value == _Tab.done
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kAksenDark.value)
                                                  : value == _Tab.done
                                                      ? const Color(0xFF8382DC)
                                                      : Color(kLight.value),
                                              border: Border.all(
                                                  color: themeController
                                                          .isDarkTheme()
                                                      ? Color(kLight.value)
                                                      : Color(
                                                          kAksenDark.value))),
                                          padding: const EdgeInsets.all(5),
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Selesai',
                                            style: TextStyle(
                                                fontFamily: 'Epilogue',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: value == _Tab.done
                                                    ? Colors.white
                                                    : themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              GetBuilder<ThemeController>(
                init: themeController,
                builder: (controller) {
                  return ValueListenableBuilder(
                    valueListenable: selectedTab,
                    builder: (context, value, child) {
                      if (value == _Tab.all) {
                        return Obx(() {
                          if (aftapController.isLoading.value) {
                            return const DonasiLoading();
                          } else if (aftapController
                              .pemeriksaanModelList.isEmpty) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                  color: themeController.isDarkTheme()
                                      ? Color(kAksenDark.value)
                                      : Color(kLight.value),
                                  border: Border.all(
                                      color: themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kAksenDark.value))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('images/no_data.png'),
                                  ReusableText(
                                      text:
                                          'Tidak Ada Data Pendonoran Saat Ini',
                                      style: appstyle(
                                        16,
                                        themeController.isDarkTheme()
                                            ? Color(kLight.value)
                                            : Color(kAksenDark.value),
                                        FontWeight.w600,
                                      ))
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  aftapController.pemeriksaanModelList.length,
                              itemBuilder: (context, index) {
                                PemeriksaanModel pemeriksaanModel =
                                    aftapController.pemeriksaanModelList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => AftapPendonor(idAftap: index));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: themeController.isDarkTheme()
                                            ? Color(kAksenDark.value)
                                            : Color(kLight.value),
                                        border: Border.all(
                                            color: themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kAksenDark.value))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableText(
                                          text: pemeriksaanModel.instansi!
                                              .toUpperCase(),
                                          textAlign: TextAlign.left,
                                          maxlines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kDark.value),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'NIK Pendonor : ',
                                            style: appstyle(
                                                13,
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                                FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: pemeriksaanModel.nik!
                                                      .toUpperCase(),
                                                  style: appstyle(
                                                      13,
                                                      themeController
                                                              .isDarkTheme()
                                                          ? Color(kLight.value)
                                                          : Color(kDark.value),
                                                      FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Tanggal Pendonoran : ',
                                            style: appstyle(
                                                13,
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                                FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: aftapController.dateTime
                                                      .format(DateTime.parse(
                                                          pemeriksaanModel
                                                              .tgl!)),
                                                  style: appstyle(
                                                      13,
                                                      themeController
                                                              .isDarkTheme()
                                                          ? Color(kLight.value)
                                                          : Color(kDark.value),
                                                      FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Status : ',
                                            style: appstyle(
                                                13,
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                                FontWeight.bold),
                                            children: <TextSpan>[
                                              const TextSpan(text: ' '),
                                              TextSpan(
                                                  text: 'Diterima Dokter',
                                                  style: appstyle(
                                                      13,
                                                      Colors.green,
                                                      FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        });
                      } else if (value == _Tab.done) {
                        return Obx(() {
                          if (aftapController.isLoading.value) {
                            return const DonasiLoading();
                          } else if (aftapController
                              .pemeriksaanModelDiterimaList.isEmpty) {
                            return Container(
                              width: width,
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                  color: themeController.isDarkTheme()
                                      ? Color(kAksenDark.value)
                                      : Color(kLight.value),
                                  border: Border.all(
                                      color: themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kAksenDark.value))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('images/no_data.png'),
                                  ReusableText(
                                      text:
                                          'Tidak Ada Data Pendonoran Yang\nDitolak Saat Ini',
                                      textAlign: TextAlign.center,
                                      maxlines: 2,
                                      style: appstyle(
                                        16,
                                        themeController.isDarkTheme()
                                            ? Color(kLight.value)
                                            : Color(kAksenDark.value),
                                        FontWeight.w600,
                                      )),
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: aftapController
                                  .pemeriksaanModelDiterimaList.length,
                              itemBuilder: (context, index) {
                                PemeriksaanModel pemeriksaanModel =
                                    aftapController
                                        .pemeriksaanModelDiterimaList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: themeController.isDarkTheme()
                                          ? Color(kAksenDark.value)
                                          : Color(kLight.value),
                                      border: Border.all(
                                          color: themeController.isDarkTheme()
                                              ? Color(kLight.value)
                                              : Color(kAksenDark.value))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReusableText(
                                        text: pemeriksaanModel.instansi!
                                            .toUpperCase(),
                                        textAlign: TextAlign.left,
                                        maxlines: 2,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: themeController.isDarkTheme()
                                              ? Color(kLight.value)
                                              : Color(kDark.value),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'NIK Pendonor : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: pemeriksaanModel.nik!
                                                    .toUpperCase(),
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Tanggal Pendonoran : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: aftapController.dateTime
                                                    .format(DateTime.parse(
                                                        pemeriksaanModel.tgl!)),
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Status : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            const TextSpan(text: ' '),
                                            TextSpan(
                                                text: 'Diterima',
                                                style: appstyle(
                                                    13,
                                                    Colors.green,
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        });
                      } else {
                        return Obx(() {
                          if (aftapController.isLoading.value) {
                            return const DonasiLoading();
                          } else if (aftapController
                              .pemeriksaanModelDitolakList.isEmpty) {
                            return Container(
                              width: width,
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                  color: themeController.isDarkTheme()
                                      ? Color(kAksenDark.value)
                                      : Color(kLight.value),
                                  border: Border.all(
                                      color: themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kAksenDark.value))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('images/no_data.png'),
                                  ReusableText(
                                      text:
                                          'Tidak Ada Data Pendonoran Yang\nDitolak Saat Ini',
                                      textAlign: TextAlign.center,
                                      maxlines: 2,
                                      style: appstyle(
                                        16,
                                        themeController.isDarkTheme()
                                            ? Color(kLight.value)
                                            : Color(kAksenDark.value),
                                        FontWeight.w600,
                                      )),
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: aftapController
                                  .pemeriksaanModelDitolakList.length,
                              itemBuilder: (context, index) {
                                PemeriksaanModel pemeriksaanModel =
                                    aftapController
                                        .pemeriksaanModelDitolakList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: themeController.isDarkTheme()
                                          ? Color(kAksenDark.value)
                                          : Color(kLight.value),
                                      border: Border.all(
                                          color: themeController.isDarkTheme()
                                              ? Color(kLight.value)
                                              : Color(kAksenDark.value))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReusableText(
                                        text: pemeriksaanModel.instansi!
                                            .toUpperCase(),
                                        textAlign: TextAlign.left,
                                        maxlines: 2,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: themeController.isDarkTheme()
                                              ? Color(kLight.value)
                                              : Color(kDark.value),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'NIK Pendonor : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: pemeriksaanModel.nik!
                                                    .toUpperCase(),
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Tanggal Pendonoran : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: aftapController.dateTime
                                                    .format(DateTime.parse(
                                                        pemeriksaanModel.tgl!)),
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Status : ',
                                          style: appstyle(
                                              13,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDark.value),
                                              FontWeight.bold),
                                          children: <TextSpan>[
                                            const TextSpan(text: ' '),
                                            TextSpan(
                                                text: 'Ditolak',
                                                style: appstyle(
                                                    13,
                                                    Color(kRed.value),
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        });
                      }
                    },
                  );
                },
              ),
              // const SizedBox(height: 20),
              // GetBuilder<ThemeController>(
              //   init: themeController,
              //   builder: (controller) {
              //     return Align(
              //       alignment: Alignment.centerLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 10),
              //         child: ReusableText(
              //             text: 'Data yang ditolak',
              //             style: appstyle(
              //                 16,
              //                 themeController.isDarkTheme()
              //                     ? Color(kLight.value)
              //                     : Color(kLightBlueContent.value),
              //                 FontWeight.bold)),
              //       ),
              //     );
              //   },
              // ),
              // const SizedBox(height: 5),
              // GetBuilder<ThemeController>(
              //   init: themeController,
              //   builder: (controller) {
              //     return Column(
              //       children: [

              //       ],
              //     );
              //   },
              // ),
              // const SizedBox(height: 20),
              // GetBuilder<ThemeController>(
              //   init: themeController,
              //   builder: (controller) {
              //     return Align(
              //       alignment: Alignment.centerLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 10),
              //         child: ReusableText(
              //             text: 'Data yang diterima',
              //             style: appstyle(
              //                 16,
              //                 themeController.isDarkTheme()
              //                     ? Color(kLight.value)
              //                     : Color(kLightBlueContent.value),
              //                 FontWeight.bold)),
              //       ),
              //     );
              //   },
              // ),
              // const SizedBox(height: 5),
              // GetBuilder<ThemeController>(
              //   init: themeController,
              //   builder: (controller) {
              //     return Column(
              //       children: [],
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
