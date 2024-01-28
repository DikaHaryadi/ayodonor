// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getdonor/controllers/histori_donor_controller.dart';
// import 'package:getdonor/controllers/themes_controller.dart';
// import 'package:getdonor/model/histori_model.dart';
// import 'package:getdonor/utils/components/storage_util.dart';

// import '../controllers/font_size_controller.dart';
// import '../utils/app_style.dart';
// import '../utils/colors.dart';
// import '../utils/reusable_text.dart';

// class HistoriDonor extends StatefulWidget {
//   final String nik;
//   // final ScrollController controller;
//   const HistoriDonor({
//     super.key,
//     required this.nik, //required this.controller
//   });

//   @override
//   State<HistoriDonor> createState() => _HistoriDonorState();
// }

// class _HistoriDonorState extends State<HistoriDonor> {
//   ThemeController themeController = Get.put(ThemeController());
//   StorageUtil storage = StorageUtil();
//   HistoriDonorController historiDonorController =
//       Get.put(HistoriDonorController());
//   int currentIndex = 0;
//   final ResponsiveTextController responsiveTextController =
//       Get.put(ResponsiveTextController());

//   double percentage = 80.0;
//   int baseMaxLines = 4;

//   @override
//   void initState() {
//     historiDonorController.fetchData(widget.nik);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     int maxLines =
//         responsiveTextController.calculateMaxLines(percentage, baseMaxLines);
//     return Obx(() {
//       if (historiDonorController.isLoading.value) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       } else if (currentIndex < historiDonorController.historiList.length) {
//         return Scaffold(
//           body: ListView(
//             // controller: widget.controller,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                   child: ReusableText(
//                       text: 'Histori Donor',
//                       style: appstyle(
//                           18,
//                           themeController.isDarkTheme()
//                               ? Color(kAksenDark.value)
//                               : Color(kDark.value),
//                           FontWeight.bold)),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: historiDonorController.historiList.length,
//                 itemBuilder: (context, index) {
//                   HistoriModel historiModel =
//                       historiDonorController.historiList[index];
//                   return Container(
//                     width: Get.width,
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 width: .15, color: Color(kDarkGrey.value)))),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ReusableText(
//                           text: historiModel.namaInstansi!,
//                           style: appstyle(14, null, FontWeight.w500),
//                         ),
//                         ReusableText(
//                           text: historiModel.lokasi!,
//                           maxlines: maxLines,
//                           style: appstyle(14, null, FontWeight.normal),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Tanggal daftar : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.normal),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: historiDonorController.dateTime.format(
//                                       DateTime.parse(historiModel.tgldaftar!)),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.normal)),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Tanggal donor : ',
//                             style: appstyle(
//                                 13,
//                                 themeController.isDarkTheme()
//                                     ? Color(kLight.value)
//                                     : Color(kDark.value),
//                                 FontWeight.normal),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: historiDonorController.dateTime.format(
//                                       DateTime.parse(historiModel.tgldonor!)),
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? Color(kLight.value)
//                                           : Color(kDark.value),
//                                       FontWeight.normal)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//         );
//       } else {
//         return Center(
//           child: ReusableText(
//             text: 'Have Never Donated Blood',
//             style: appstyle(
//                 16,
//                 themeController.isDarkTheme()
//                     ? Color(kLight.value)
//                     : Color(kAksenDark.value),
//                 FontWeight.w700),
//           ),
//         );
//       }
//     });
//   }
// }
