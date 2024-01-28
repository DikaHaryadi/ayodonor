import 'dart:convert';

import 'package:get/get.dart';
import 'package:getdonor/model/histori_model.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../utils/app_constants.dart';

class HistoriDonorController extends GetxController {
  // bool showloading = true;
  var isLoading = false.obs;
  var historiList = <HistoriModel>[].obs;
  HistoriModel? historiModel;
  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
  final StorageUtil storage = StorageUtil();

  @override
  void onInit() {
    fetchData(storage.getNik());
    super.onInit();
  }

  Future<void> fetchData(String nik) async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          '${ApiConstants.baseUrl}${ApiConstants.getHistoriDonor}?nik=$nik')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as List;
        historiList
            .assignAll(result.map((json) => HistoriModel.fromJson(json)));
        if (historiList.isNotEmpty) {
          historiModel = historiList[0];
          update();
        } else {
          // Handle the case where no data is available
          historiModel = null;
        }
      } else {
        Get.snackbar('Warning!',
            'Kesalahan dalam mengambil data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Warning!', 'Terjadi Error Ketika Mengambil Data: $e');
    } finally {
      isLoading(false);
    }
  }
}
