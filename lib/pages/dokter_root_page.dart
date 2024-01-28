import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/check_nik_controller.dart';
import 'package:getdonor/pages/info_profile.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/pemeriksaan_controller.dart';
import '../controllers/themes_controller.dart';
import '../model/daftar_donor_model.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/donasi_loading.dart';
import '../utils/reusable_text.dart';

enum _Tab {
  all,
  done,
}

class DokterRootPage extends StatefulWidget {
  const DokterRootPage({super.key});

  @override
  State<DokterRootPage> createState() => _DokterRootPageState();
}

class _DokterRootPageState extends State<DokterRootPage> {
  late ThemeController themeController;
  CheckNikController checkNikController = Get.put(CheckNikController());
  PemeriksaanController pemeriksaanController =
      Get.put(PemeriksaanController());

  final StorageUtil storage = StorageUtil();
  final selectedTab = ValueNotifier(_Tab.all);
  var width = Get.width;

  final int maxBackPressCount = 2;
  final RxInt backPressCount = 0.obs;

  void initializeData() {
    // pemeriksaanController.fetchPemeriksaan(storage.getNik());
    // pemeriksaanController.fetchDaftarDarahDokter();
    pemeriksaanController
        .fetchFilterPendaftaranPendonoran(storage.getInstansiBekerja());
    pemeriksaanController.fetchFilterPendonoranDone('1');
  }

  @override
  void initState() {
    themeController = Get.find<ThemeController>();
    // initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
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
              physics: const AlwaysScrollableScrollPhysics(),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  BoxShadow(
                                    offset: const Offset(5, 0),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
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
                                        storage.getNameDokter() == ''
                                            ? const SizedBox.shrink()
                                            : ReusableText(
                                                text: storage.getNameDokter(),
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16,
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(
                                                            kLightGrey.value),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                        storage.getPhone() == ''
                                            ? const Text('')
                                            : SelectableText(
                                                'Nomer Telepon | ${storage.getPhone()}',
                                                style: appstyle(
                                                    12,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(
                                                            kLightGrey.value),
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
                                              ApiUtils.getDokterImageUrl(
                                                  storage.getImg()))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
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
                                                        ? const Color(
                                                            0xFF8382DC)
                                                        : Color(
                                                            kAksenDark.value)
                                                    : value == _Tab.all
                                                        ? const Color(
                                                            0xFF8382DC)
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
                                              selectedTab.value = _Tab.done;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? value == _Tab.done
                                                        ? const Color(
                                                            0xFF8382DC)
                                                        : Color(
                                                            kAksenDark.value)
                                                    : value == _Tab.done
                                                        ? const Color(
                                                            0xFF8382DC)
                                                        : Color(kLight.value),
                                                border: Border.all(
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(
                                                            kAksenDark.value))),
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
                ValueListenableBuilder(
                  valueListenable: selectedTab,
                  builder: (context, value, child) {
                    return value == _Tab.all
                        ? Obx(() {
                            if (pemeriksaanController.isLoading.value) {
                              return const DonasiLoading();
                            } else if (pemeriksaanController
                                .daftarDonorList.isEmpty) {
                              return GetBuilder<ThemeController>(
                                init: themeController,
                                builder: (_) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    decoration: BoxDecoration(
                                        color: themeController.isDarkTheme()
                                            ? Color(kAksenDark.value)
                                            : Color(kLight.value),
                                        border: Border.all(
                                            color: themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kAksenDark.value))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/no_data.png'),
                                        ReusableText(
                                            text:
                                                'Tidak Ada Pendonoran Saat Ini',
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
                                },
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: pemeriksaanController
                                    .daftarDonorList.length,
                                itemBuilder: (context, index) {
                                  DaftarDonorModel daftarDonorModel =
                                      pemeriksaanController
                                          .daftarDonorList[index];
                                  return GestureDetector(
                                      onTap: () {
                                        checkNikController.checkNikPemeriksaan(
                                            daftarDonorModel.nik!);
                                        // ini nanti route nya ke pemeriksaanController, bakalan jadi di table pemeriksaans
                                      },
                                      child: GetBuilder<ThemeController>(
                                        init: themeController,
                                        builder: (controller) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? Color(kAksenDark.value)
                                                    : Color(kLight.value),
                                                border: Border.all(
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(
                                                            kAksenDark.value))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ReusableText(
                                                  text: daftarDonorModel
                                                      .namaInstansi!
                                                      .toUpperCase(),
                                                  maxlines: 2,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'NIK Pendonor : ',
                                                    style: appstyle(
                                                        13,
                                                        themeController
                                                                .isDarkTheme()
                                                            ? Color(
                                                                kLight.value)
                                                            : Color(
                                                                kDark.value),
                                                        FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: daftarDonorModel
                                                              .nik!
                                                              .toUpperCase(),
                                                          style: appstyle(
                                                              13,
                                                              themeController
                                                                      .isDarkTheme()
                                                                  ? Color(kLight
                                                                      .value)
                                                                  : Color(kDark
                                                                      .value),
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'Tanggal Pendonoran : ',
                                                    style: appstyle(
                                                        13,
                                                        themeController
                                                                .isDarkTheme()
                                                            ? Color(
                                                                kLight.value)
                                                            : Color(
                                                                kDark.value),
                                                        FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: pemeriksaanController
                                                              .dateTime
                                                              .format(DateTime.parse(
                                                                  daftarDonorModel
                                                                      .tglDonor!)),
                                                          style: appstyle(
                                                              13,
                                                              themeController
                                                                      .isDarkTheme()
                                                                  ? Color(kLight
                                                                      .value)
                                                                  : Color(kDark
                                                                      .value),
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Status : ',
                                                        style: appstyle(
                                                            13,
                                                            themeController
                                                                    .isDarkTheme()
                                                                ? Color(kLight
                                                                    .value)
                                                                : Color(kDark
                                                                    .value),
                                                            FontWeight.bold),
                                                        children: <TextSpan>[
                                                          const TextSpan(
                                                              text: ' '),
                                                          TextSpan(
                                                              text: daftarDonorModel
                                                                          .status ==
                                                                      '0'
                                                                  ? 'Belum diperiksa'
                                                                  : 'Sudah disetujui',
                                                              style: appstyle(
                                                                  13,
                                                                  themeController
                                                                          .isDarkTheme()
                                                                      ? Color(kLight
                                                                          .value)
                                                                      : Color(kDark
                                                                          .value),
                                                                  FontWeight
                                                                      .bold)),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        checkNikController
                                                            .checkNikKhususDokter(
                                                                daftarDonorModel
                                                                    .nik!);
                                                      },
                                                      child: const ReusableText(
                                                          text:
                                                              'ubah data pendonor',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'Poppins',
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ));
                                },
                              );
                            }
                          })
                        : Obx(() {
                            if (pemeriksaanController.isLoading.value) {
                              return const DonasiLoading();
                            } else if (pemeriksaanController
                                .daftarDonorDoneList.isEmpty) {
                              return GetBuilder<ThemeController>(
                                init: themeController,
                                builder: (_) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    decoration: BoxDecoration(
                                        color: themeController.isDarkTheme()
                                            ? Color(kAksenDark.value)
                                            : Color(kLight.value),
                                        border: Border.all(
                                            color: themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kAksenDark.value))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/no_data.png'),
                                        ReusableText(
                                            text:
                                                'Tidak Ada Pendonoran Saat Ini',
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
                                },
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: pemeriksaanController
                                    .daftarDonorDoneList.length,
                                itemBuilder: (context, index) {
                                  DaftarDonorModel daftarDonorModel =
                                      pemeriksaanController
                                          .daftarDonorDoneList[index];
                                  return GetBuilder<ThemeController>(
                                    init: themeController,
                                    builder: (controller) {
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
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kAksenDark.value))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ReusableText(
                                              text: daftarDonorModel
                                                  .namaInstansi!
                                                  .toUpperCase(),
                                              maxlines: 2,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'NIK Pendonor : ',
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: daftarDonorModel
                                                          .nik!
                                                          .toUpperCase(),
                                                      style: appstyle(
                                                          13,
                                                          themeController
                                                                  .isDarkTheme()
                                                              ? Color(
                                                                  kLight.value)
                                                              : Color(
                                                                  kDark.value),
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Tanggal Pendonoran : ',
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: pemeriksaanController
                                                          .dateTime
                                                          .format(DateTime.parse(
                                                              daftarDonorModel
                                                                  .tglDonor!)),
                                                      style: appstyle(
                                                          13,
                                                          themeController
                                                                  .isDarkTheme()
                                                              ? Color(
                                                                  kLight.value)
                                                              : Color(
                                                                  kDark.value),
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Status : ',
                                                style: appstyle(
                                                    13,
                                                    themeController
                                                            .isDarkTheme()
                                                        ? Color(kLight.value)
                                                        : Color(kDark.value),
                                                    FontWeight.bold),
                                                children: <TextSpan>[
                                                  const TextSpan(text: ' '),
                                                  TextSpan(
                                                      text: daftarDonorModel
                                                                  .status ==
                                                              '0'
                                                          ? 'Belum diperiksa'
                                                          : 'Sudah disetujui',
                                                      style: appstyle(
                                                          13,
                                                          themeController
                                                                  .isDarkTheme()
                                                              ? Color(
                                                                  kLight.value)
                                                              : Color(
                                                                  kDark.value),
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
