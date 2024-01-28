import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/model/tabel_darah.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ionicons/ionicons.dart';

import '../utils/debouncer.dart';

class TableController extends GetxController {
  var isLoading = false.obs;
  RxList<TabelModel> rows = <TabelModel>[].obs;
  RxList<TabelModel> filteredRows = <TabelModel>[].obs;

  final ctrler = TextEditingController();
  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void onInit() {
    super.onInit();
    getMaster();
  }

  getMaster() async {
    try {
      isLoading(true);
      final response = await http.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getBloodStock}'));
      if (response.statusCode == 200) {
        List<dynamic> isi = json.decode(response.body);
        List<TabelModel> models = isi.map<TabelModel>((data) {
          return TabelModel.fromJson(data);
        }).toList();
        rows.value = models;
      } else {
        Get.snackbar('Error :', 'Ada yang salah dari server');
      }
    } catch (e) {
      Get.snackbar('Error :', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void filterDataList(String searchText) {
    _debouncer(() {
      List<TabelModel> filteredList = rows.where((row) {
        String instansi = row.instansi ?? '';
        return instansi.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      filteredRows.value = filteredList;

      if (filteredList.isEmpty) {
        Get.snackbar(
          'Perhatian :',
          'Nama Instansi Tidak Tersedia',
          icon: const Icon(Ionicons.warning),
          shouldIconPulse: true,
        );
      }
    });
  }

  void clearFilter() {
    filteredRows.clear();
    ctrler.clear();
  }
}
