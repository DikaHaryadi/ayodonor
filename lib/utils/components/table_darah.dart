import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/table_darah_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/utils/Custom/search_textfield.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/components/data_table.dart';
import 'package:getdonor/utils/components/table_loading.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:ionicons/ionicons.dart';

class TableDarah extends StatefulWidget {
  const TableDarah({Key? key}) : super(key: key);

  @override
  State<TableDarah> createState() => _TableDarahState();
}

class _TableDarahState extends State<TableDarah> {
  late double offset = 0.0;
  late ThemeController themeController = Get.put(ThemeController());
  bool? textVisible = true;

  @override
  void initState() {
    textVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TableController tableController = Get.put(TableController());
    var data = tableController.filteredRows.isNotEmpty
        ? tableController.filteredRows
        : tableController.rows;

    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (controller) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.2,
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Obx(() => tableController.isLoading.value
                  ? const TableLoading()
                  : PaginatedDataTable(
                      sortColumnIndex: 0,
                      source: MyDataTableSource(
                          ctx: context, count: data.length, myData: data),
                      rowsPerPage: 5,
                      columnSpacing: 40,
                      columns: [
                        DataColumn(
                          label: ReusableText(
                            text: 'No',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kLightBlueContent.value),
                                FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: ReusableText(
                            text: 'Provinsi',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDarkGrey.value),
                                FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: ReusableText(
                            text: 'Jumlah',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kLightGrey.value),
                                FontWeight.w600),
                          ),
                        ),
                      ],
                    )),
            ),
            const SizedBox(height: 5),
            CustomTextFieldSearch(
              offset: offset,
              name: 'Stock Darah',
              textEditingController: tableController.ctrler,
              suffixIcon: textVisible! ? null : Ionicons.trash,
              clearFunction: () {
                setState(() {
                  tableController.ctrler.text == ''
                      ? textVisible = true
                      : textVisible = false;
                });
                tableController.clearFilter();
              },
              function: (value) {
                setState(() {
                  tableController.ctrler.text == ''
                      ? textVisible = true
                      : textVisible = false;
                });
                tableController.filterDataList(value);
              },
              subName: 'Palang Merah Indonesia',
              nameTextField: 'Cari Nama Instansi',
            ),
          ],
        );
      },
    );
  }
}
