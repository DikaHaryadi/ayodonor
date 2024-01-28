import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/pemeriksaan_controller.dart';
import 'package:getdonor/model/pemeriksaan_model.dart';
import 'package:getdonor/utils/components/app_bar.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:intl/intl.dart';

import '../controllers/themes_controller.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';

class BloodInformation extends StatefulWidget {
  final String nik;
  const BloodInformation({super.key, required this.nik});

  @override
  State<BloodInformation> createState() => _BloodInformationState();
}

class _BloodInformationState extends State<BloodInformation> {
  late ThemeController themeController;
  PemeriksaanController pemeriksaanController =
      Get.put(PemeriksaanController());

  final StorageUtil storage = StorageUtil();
  List<Color> infoColor = [];
  int currentIndex = 0;

  void initializeData() {
    pemeriksaanController.fetchPemeriksaan(widget.nik);
  }

  @override
  void initState() {
    themeController = Get.find<ThemeController>();

    initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          bgColor: themeController.isDarkTheme()
              ? Color(kLightGrey.value)
              : Color(kLightBlueContent.value),
          iconColor: Color(kLight.value),
          text: 'Blood Information',
          centerTitle: false,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: RefreshIndicator(onRefresh: () async {
        initializeData();
      }, child: Obx(() {
        if (pemeriksaanController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (currentIndex <
            pemeriksaanController.pemeriksaanList.length) {
          PemeriksaanModel pemeriksaanModel =
              pemeriksaanController.pemeriksaanList[currentIndex];

          return ListView(
            padding: const EdgeInsets.all(5),
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: getImage(), fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReusableText(
                          text: storage.getEmail(),
                          textAlign: TextAlign.left,
                          maxlines: 2,
                          style: appstyle(
                            13,
                            themeController.isDarkTheme()
                                ? Color(kLight.value)
                                : Color(kDark.value),
                            FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'NIK : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: storage.getNik(),
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Tinggi Badan : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: pemeriksaanModel.tinggiBadan!
                                      .toUpperCase(),
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Berat Badan : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: pemeriksaanModel.beratBadan!
                                      .toUpperCase(),
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Gula : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: pemeriksaanModel.gula == '0'
                                      ? 'Tidak ada'
                                      : 'Ada',
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Kolestrol : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: pemeriksaanModel.kolesterol == '0'
                                      ? 'Tidak ada'
                                      : 'Ada',
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.bold)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Asam Urat : ',
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      pemeriksaanModel.asamUrat!.toUpperCase(),
                                  style: appstyle(13, null, FontWeight.bold)),
                            ],
                          ),
                        ),
                        ReusableText(
                          text:
                              'Gol Darah & Resus: ${pemeriksaanModel.golDarah}${pemeriksaanModel.resus}',
                          maxlines: 2,
                          textAlign: TextAlign.center,
                          style: appstyle(
                            13,
                            null,
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ReusableText(
                  text: 'Pemeriksaan Terakhir',
                  style: appstyle(
                      15,
                      themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : Color(kDarkGrey.value),
                      FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pemeriksaanController.pemeriksaanList.length,
                itemBuilder: (context, index) {
                  PemeriksaanModel pemeriksaanModel =
                      pemeriksaanController.pemeriksaanList[index];
                  int itemNumber = index + 1;
                  final dateTime = DateFormat("EEE, d/M/y", 'id_ID');
                  return Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: themeController.isDarkTheme()
                                  ? Color(kAksenDark.value)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(
                                  color: getRandomColor(), width: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text:
                                        'Tkn. Darah : ${pemeriksaanModel.tekananDarah}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  ReusableText(
                                    text:
                                        'Systolic : ${pemeriksaanModel.systolic}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  ReusableText(
                                    text:
                                        'Diastolic : ${pemeriksaanModel.diastolic}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  ReusableText(
                                    text: 'Mea count :  200',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: 'Pulse : ${pemeriksaanModel.pulse}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  ReusableText(
                                    text:
                                        'Heart Rate : ${pemeriksaanModel.heartRate}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  ReusableText(
                                    text:
                                        'Tgl :  ${dateTime.format(DateTime.parse(pemeriksaanModel.tgl!))}',
                                    maxlines: 2,
                                    textAlign: TextAlign.center,
                                    style: appstyle(
                                      13,
                                      null,
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: getRandomColor(),
                                width: .4,
                              ),
                            ),
                            child: ReusableText(
                              text: '$itemNumber',
                              style: appstyle(
                                13,
                                null,
                                FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  );
                },
              )
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/no_data.png'),
                ReusableText(
                    text: 'Belum Pernah Mendonorkan Darah',
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
        }
      })),
    );
  }

  Color getRandomColor() {
    final random = Random();
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    infoColor.add(color);
    return color;
  }

  NetworkImage getImage() {
    if (storage.getLogin() == 'False') {
      return const NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      );
    } else {
      if (storage.getStatus() == '1') {
        return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
      } else if (storage.getStatus() == '2') {
        return NetworkImage(storage.getImgGoogle());
      } else if (storage.getStatus() == '3') {
        return NetworkImage(storage.getImgFb());
      } else {
        return const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        );
      }
    }
  }
}

// class DokterPemeriksaanInfo extends StatefulWidget {
//   final String instansi;
//   const DokterPemeriksaanInfo({super.key, required this.instansi});

//   @override
//   State<DokterPemeriksaanInfo> createState() => _DokterPemeriksaanInfoState();
// }

// class _DokterPemeriksaanInfoState extends State<DokterPemeriksaanInfo> {
//   late ThemeController themeController;
//   PemeriksaanController pemeriksaanController =
//       Get.put(PemeriksaanController());

//   final StorageUtil storage = StorageUtil();
//   List<Color> infoColor = [];
//   int currentIndex = 0;

//   void initializeData() {
//     pemeriksaanController.fetchFilterPendaftaranPendonoran(widget.instansi);
//   }

//   @override
//   void initState() {
//     themeController = Get.find<ThemeController>();

//     initializeData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (pemeriksaanController.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (currentIndex <
//             pemeriksaanController.daftarDonorList.length) {
//           DaftarDonorModel pemeriksaanModel =
//               pemeriksaanController.daftarDonorList[currentIndex];

//           return ListView(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(5),
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       showGeneralDialog(
//                         barrierDismissible: true,
//                         barrierLabel: "Kartu Donor",
//                         context: context,
//                         transitionDuration: const Duration(milliseconds: 400),
//                         transitionBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                           Tween<Offset> tween;
//                           tween = Tween(
//                               begin: const Offset(0, -1), end: Offset.zero);
//                           return SlideTransition(
//                             position: tween.animate(
//                               CurvedAnimation(
//                                   parent: animation, curve: Curves.easeInOut),
//                             ),
//                             child: child,
//                           );
//                         },
//                         pageBuilder: (context, _, __) => Center(
//                           child: Container(
//                             padding: const EdgeInsets.only(left: 10, right: 10),
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 2,
//                             child: const Scaffold(body: KartuDonor()),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       width: 150,
//                       height: 150,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: getImage(), fit: BoxFit.cover)),
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ReusableText(
//                           text: storage.getEmail(),
//                           textAlign: TextAlign.center,
//                           style: appstyle(
//                             13,
//                             themeController.isDarkTheme()
//                                 ? Color(kLight.value)
//                                 : Color(kDark.value),
//                             FontWeight.bold,
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'NIK : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: storage.getNik(),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Tinggi Badan : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: pemeriksaanModel.nik!.toUpperCase(),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Berat Badan : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: pemeriksaanModel.namaInstansi!
//                                       .toUpperCase(),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Gula : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: pemeriksaanModel.lokasi!.toUpperCase(),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Kolestrol : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text:
//                                       pemeriksaanModel.tglDaftar!.toUpperCase(),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Asam Urat : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.bold),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text:
//                                       pemeriksaanModel.tglDonor!.toUpperCase(),
//                                   style: appstyle(13, null, FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         ReusableText(
//                           text: 'Status: ${pemeriksaanModel.status}',
//                           maxlines: 2,
//                           textAlign: TextAlign.center,
//                           style: appstyle(
//                             13,
//                             null,
//                             FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         } else {
//           return Center(
//             child: ReusableText(
//               text: 'Tidak Ada',
//               style: appstyle(
//                   16,
//                   themeController.isDarkTheme()
//                       ? Color(kLight.value)
//                       : Color(kAksenDark.value),
//                   FontWeight.w700),
//             ),
//           );
//         }
//       }),
//     );
//   }

//   Color getRandomColor() {
//     final random = Random();
//     final color = Color.fromARGB(
//       255,
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//     );
//     infoColor.add(color);
//     return color;
//   }

//   NetworkImage getImage() {
//     if (storage.getLogin() == 'False') {
//       return const NetworkImage(
//         'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
//       );
//     } else {
//       if (storage.getStatus() == '1') {
//         return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
//       } else if (storage.getStatus() == '2') {
//         return NetworkImage(storage.getImgGoogle());
//       } else if (storage.getStatus() == '3') {
//         return NetworkImage(storage.getImgFb());
//       } else {
//         return const NetworkImage(
//           'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
//         );
//       }
//     }
//   }
// }
