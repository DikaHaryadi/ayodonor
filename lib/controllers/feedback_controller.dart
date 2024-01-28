import 'dart:convert';

import 'package:get/get.dart';
import 'package:getdonor/model/feedback_model.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class FeedBackController extends GetxController {
  var isLoading = false.obs;
  var feedbackList = <FeedBackModel>[].obs;

  @override
  Future<void> onInit() async {
    fetchData();
    super.onInit();
  }

  fetchData() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.tryParse('${ApiConstants.baseUrl}${ApiConstants.getFeedBack}')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as List;
        feedbackList
            .assignAll(result.map((json) => FeedBackModel.fromJson(json)));
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

  Future<void> refreshData() async {
    await fetchData();
  }
}
