import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/detail_table_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/table_detail_model.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/expandable_container.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/Custom/search_textfield.dart';
import '../utils/colors.dart';

class NamaInstansi extends StatelessWidget {
  final int idInstansi;
  final String namaInstansi;
  NamaInstansi(
      {super.key, required this.idInstansi, required this.namaInstansi});

  final double offset = 0.0;
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SummaryDarahController(
      idInstansi: idInstansi,
      namaInstansi: namaInstansi,
    ));
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SafeArea(
            child: Container(
              color: Color(kLightBlueContent.value),
              child: CustomTextFieldSearchStockDarah(
                offset: offset,
                name: namaInstansi,
                textEditingController: controller.searchController,
                clearFunction: () {
                  controller.searchController.text = '';
                  controller.filterData('');
                },
                function: controller.filterData,
                nameTextField: 'Cari Nama Instansi',
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Obx(
          () => controller.isLoading.value
              ? themeController.isDarkTheme()
                  ? Lottie.asset('images/stock_loading.json',
                      width: Get.width, height: Get.height)
                  : Lottie.asset('images/stock_loading_dark.json',
                      width: Get.width, height: Get.height)
              : ListView.builder(
                  itemCount: controller.filteredData.length,
                  itemBuilder: (context, index) {
                    SummaryTotalBlood data = controller.filteredData[index];
                    var item = controller.filteredData[index];
                    return ExpandableContainer(
                      // textContent: data.alamat!,
                      textTitle: data.namaInstansi!,
                      statistik: Obx(
                        () => controller.isLoading.value
                            ? themeController.isDarkTheme()
                                ? Lottie.asset('images/stock_loading.json',
                                    width: Get.width, height: Get.height)
                                : Lottie.asset('images/stock_loading_dark.json',
                                    width: Get.width, height: Get.height)
                            : Column(
                                children: [
                                  SfCartesianChart(
                                    title: ChartTitle(text: ''),
                                    plotAreaBorderColor: Colors.red,
                                    backgroundColor: Colors.transparent,
                                    plotAreaBackgroundColor: Colors.transparent,
                                    borderWidth: 3,
                                    series: <ChartSeries>[
                                      ColumnSeries<SummaryTotalBlood, String>(
                                          dataSource: [
                                            item
                                          ], // Use 'item' instead of 'item'
                                          xValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.namaInstansi,
                                          yValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.a,
                                          color: const Color(0xFFFAF7F0),
                                          dataLabelSettings: DataLabelSettings(
                                              color: Color(kAksenDark.value),
                                              isVisible: true)),
                                      ColumnSeries<SummaryTotalBlood, String>(
                                          dataSource: [item],
                                          xValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.namaInstansi,
                                          yValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.b,
                                          color: const Color(0xFFCDFCF6),
                                          dataLabelSettings: DataLabelSettings(
                                              color: Color(kAksenDark.value),
                                              isVisible: true)),
                                      ColumnSeries<SummaryTotalBlood, String>(
                                          dataSource: [item],
                                          xValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.namaInstansi,
                                          yValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.o,
                                          color: const Color(0xFFBCCEF8),
                                          dataLabelSettings: DataLabelSettings(
                                              color: Color(kAksenDark.value),
                                              isVisible: true)),
                                      ColumnSeries<SummaryTotalBlood, String>(
                                          dataSource: [item],
                                          xValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.namaInstansi,
                                          yValueMapper:
                                              (SummaryTotalBlood data, _) =>
                                                  data.ab,
                                          color: const Color(0xFF98A8F8),
                                          dataLabelSettings: DataLabelSettings(
                                              color: Color(kAksenDark.value),
                                              isVisible: true)),
                                    ],
                                    primaryXAxis: CategoryAxis(
                                      labelStyle: appstyle(
                                          14,
                                          const Color(0xFF98A8F8),
                                          FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            color: const Color(0xFFFAF7F0),
                                          ),
                                          const SizedBox(width: 10),
                                          ReusableText(
                                              text: 'A',
                                              style: appstyle(
                                                  13,
                                                  Color(kLight.value),
                                                  FontWeight.normal))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            color: const Color(0xFFCDFCF6),
                                          ),
                                          const SizedBox(width: 10),
                                          ReusableText(
                                              text: 'B',
                                              style: appstyle(
                                                  13,
                                                  Color(kLight.value),
                                                  FontWeight.normal))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            color: const Color(0xFFBCCEF8),
                                          ),
                                          const SizedBox(width: 10),
                                          ReusableText(
                                              text: 'O',
                                              style: appstyle(
                                                  13,
                                                  Color(kLight.value),
                                                  FontWeight.normal))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            color: const Color(0xFF98A8F8),
                                          ),
                                          const SizedBox(width: 10),
                                          ReusableText(
                                              text: 'AB',
                                              style: appstyle(
                                                  13,
                                                  Color(kLight.value),
                                                  FontWeight.normal))
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(kAksenDark.value),
                                          width: 1.5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'images/google-maps.png',
                                          width: 20,
                                          fit: BoxFit.contain,
                                          semanticLabel: 'alamat',
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: SelectableText(
                                            item.alamat!,
                                            textAlign: TextAlign.left,
                                            style: appstyle(
                                                13,
                                                const Color(0xFFFAF7F0),
                                                FontWeight.w400),
                                            selectionControls:
                                                CupertinoTextSelectionControls(),
                                            showCursor: true,
                                            cursorColor:
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDarkGrey.value),
                                            cursorWidth:
                                                2, // Set the cursor width
                                            cursorRadius:
                                                const Radius.circular(1),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.launchMaps(
                                                double.parse(item.lat!),
                                                double.parse(item.lng!));
                                          },
                                          child: Icon(
                                            Icons.directions,
                                            color: Color(kLight.value),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
        ));
  }
}

// class DetailStockDarah extends StatelessWidget {
//   final int idInstansi;
//   final String namaInstansi;
//   DetailStockDarah(
//       {Key? key, required this.idInstansi, required this.namaInstansi})
//       : super(key: key);

//   final double offset = 0.0;

//   final ThemeController themeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SummaryDarahController(
//       idInstansi: idInstansi,
//       namaInstansi: namaInstansi,
//     ));

//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: SafeArea(
//             child: Container(
//               color: Color(kLightBlueContent.value),
//               child: CustomTextFieldSearchStockDarah(
//                 offset: offset,
//                 name: namaInstansi,
//                 textEditingController: controller.searchController,
//                 clearFunction: () {
//                   controller.searchController.text = '';
//                   controller.filterData('');
//                 },
//                 function: controller.filterData,
//                 nameTextField: 'Cari Nama Instansi',
//               ),
//             ),
//           ),
//         ),
//         resizeToAvoidBottomInset: true,
//         body: Obx(() => controller.isLoading.value
//             ? themeController.isDarkTheme()
//                 ? Lottie.asset('images/stock_loading.json',
//                     width: Get.width, height: Get.height)
//                 : Lottie.asset('images/stock_loading_dark.json',
//                     width: Get.width, height: Get.height)
//             : ListView.builder(
//                 itemCount: controller.filteredData.length,
//                 itemBuilder: (context, index) {
//                   var item = controller.filteredData[index];
//                   return Container(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: themeController.isDarkTheme()
//                               ? Color(kAksenDark.value)
//                               : Color(kLightGrey.value),
//                           width: .5),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SfCartesianChart(
//                           title: ChartTitle(text: ''),
//                           backgroundColor:
//                               Theme.of(context).scaffoldBackgroundColor,
//                           plotAreaBackgroundColor:
//                               Theme.of(context).scaffoldBackgroundColor,
//                           borderWidth: 3,
//                           series: <ChartSeries>[
//                             ColumnSeries<SummaryTotalBlood, String>(
//                                 dataSource: [
//                                   item
//                                 ], // Use 'item' instead of 'item'
//                                 xValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.namaInstansi,
//                                 yValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.a,
//                                 color: themeController.isDarkTheme()
//                                     ? const Color(0xFFFAF7F0)
//                                     : const Color(0xFF423737)),
//                             ColumnSeries<SummaryTotalBlood, String>(
//                               dataSource: [item],
//                               xValueMapper: (SummaryTotalBlood data, _) =>
//                                   data.namaInstansi,
//                               yValueMapper: (SummaryTotalBlood data, _) =>
//                                   data.b,
//                               color: const Color(0xFFCDFCF6),
//                             ),
//                             ColumnSeries<SummaryTotalBlood, String>(
//                                 dataSource: [item],
//                                 xValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.namaInstansi,
//                                 yValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.o,
//                                 color: const Color(0xFFBCCEF8)),
//                             ColumnSeries<SummaryTotalBlood, String>(
//                                 dataSource: [item],
//                                 xValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.namaInstansi,
//                                 yValueMapper: (SummaryTotalBlood data, _) =>
//                                     data.ab,
//                                 color: const Color(0xFF98A8F8)),
//                           ],
//                           primaryXAxis: CategoryAxis(
//                               labelStyle: appstyle(14, const Color(0xFF98A8F8),
//                                   FontWeight.bold)),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 15,
//                                   height: 15,
//                                   color: themeController.isDarkTheme()
//                                       ? const Color(0xFFFAF7F0)
//                                       : const Color(0xFF423737),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ReusableText(
//                                     text: 'A',
//                                     style:
//                                         appstyle(13, null, FontWeight.normal))
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 15,
//                                   height: 15,
//                                   color: const Color(0xFFCDFCF6),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ReusableText(
//                                     text: 'B',
//                                     style:
//                                         appstyle(13, null, FontWeight.normal))
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 15,
//                                   height: 15,
//                                   color: const Color(0xFFBCCEF8),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ReusableText(
//                                     text: 'O',
//                                     style:
//                                         appstyle(13, null, FontWeight.normal))
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 15,
//                                   height: 15,
//                                   color: const Color(0xFF98A8F8),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ReusableText(
//                                     text: 'AB',
//                                     style:
//                                         appstyle(13, null, FontWeight.normal))
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 'images/google-maps.png',
//                                 width: 20,
//                                 fit: BoxFit.contain,
//                                 semanticLabel: 'alamat',
//                               ),
//                               const SizedBox(width: 5),
//                               Expanded(
//                                 child: SelectableText(
//                                   item.alamat!,
//                                   textAlign: TextAlign.left,
//                                   style: appstyle(
//                                       13,
//                                       themeController.isDarkTheme()
//                                           ? const Color(0xFFFAF7F0)
//                                           : const Color(0xFF423737),
//                                       FontWeight.w400),
//                                   selectionControls:
//                                       CupertinoTextSelectionControls(),
//                                   showCursor: true,
//                                   cursorColor: themeController.isDarkTheme()
//                                       ? Color(kLight.value)
//                                       : Color(kDarkGrey.value),
//                                   cursorWidth: 2, // Set the cursor width
//                                   cursorRadius: const Radius.circular(1),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   controller.launchMaps(double.parse(item.lat!),
//                                       double.parse(item.lng!));
//                                 },
//                                 child: const Icon(Icons.directions),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )));
//   }
// }
