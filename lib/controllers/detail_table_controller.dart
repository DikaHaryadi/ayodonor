import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/model/table_detail_model.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SummaryDarahController extends GetxController {
  final int idInstansi;
  final String namaInstansi;

  SummaryDarahController({
    required this.idInstansi,
    required this.namaInstansi,
  });

  RxList<SummaryTotalBlood> chartData = <SummaryTotalBlood>[].obs;
  var filteredData = <SummaryTotalBlood>[].obs;
  // RxList<SummaryTotalBlood> filteredData = <SummaryTotalBlood>[].obs;

  final double offset = 0.0;
  RxBool textVisible = true.obs;
  var isLoading = false.obs;

  var searchController = TextEditingController();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.detailStockDarah}?id_prov=$idInstansi'));
      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        List<SummaryTotalBlood> newData = [];
        if (isi['success']) {
          newData = List.from(isi['data']).map((item) {
            return SummaryTotalBlood.fromJson(item);
          }).toList();
        }
        chartData.assignAll(newData);
        filteredData.assignAll(newData);
      } else {
        Get.snackbar('HTTP Error: ', '${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error: ', '$e');
    } finally {
      isLoading(false);
    }
  }

  void filterData(String keyword) {
    if (keyword.isEmpty) {
      filteredData.assignAll(chartData); // Restore the original data
    } else {
      filteredData.assignAll(chartData.where((item) {
        return item.namaInstansi!.toLowerCase().contains(keyword.toLowerCase());
      }));
    }
  }

  void launchMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan dalam membuka maps: $e');
    }
  }
}
