import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/model/tabel_darah.dart';
import 'package:getdonor/utils/reusable_text.dart';

import '../../pages/detail_stock_darah.dart';
import '../app_style.dart';

class MyDataTableSource extends DataTableSource {
  final List<TabelModel> myData;
  final int count;
  final BuildContext ctx;

  MyDataTableSource(
      {required this.myData, required this.count, required this.ctx});

  DataRow recentFileDataRow(int index) {
    final dataRow = myData[index];
    int itemNumber = index + 1;

    return DataRow(
      cells: [
        DataCell(
          ReusableText(
              text: '$itemNumber', style: appstyle(14, null, FontWeight.w400)),
        ),
        DataCell(InkWell(
          onTap: () {
            Get.to(() => NamaInstansi(
                  idInstansi: dataRow.id,
                  namaInstansi: dataRow.instansi ?? 'Instansi Not Found',
                ));
          },
          child: ReusableText(
              text: dataRow.instansi ?? '',
              style: appstyle(12, null, FontWeight.normal)),
        )),
        DataCell(
          ReusableText(
              text: dataRow.jumlah?.toString() ?? '',
              style: appstyle(12, null, FontWeight.normal)),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(index);
    } else {
      return null;
    }
  }
}
