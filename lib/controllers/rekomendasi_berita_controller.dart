import 'dart:convert';

import 'package:get/get.dart';
import 'package:getdonor/model/rekomendasi_model.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class BeritaRekomendasiController extends GetxController {
  var isLoading = false.obs;
  var beritaRekomendasiList = <RekomendasiModel>[].obs;

  @override
  Future<void> onInit() async {
    fetchData();
    super.onInit();
  }

  fetchData() async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          '${ApiConstants.baseUrl}${ApiConstants.getnewsRecoURL}')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as List;
        beritaRekomendasiList
            .assignAll(result.map((json) => RekomendasiModel.fromJson(json)));
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

  String formatTimeElapsed(DateTime donationDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(donationDate);

    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      int remainingDays = difference.inDays - (years * 365);
      int months = (remainingDays / 30).floor();
      return '$years year${years > 1 ? "s" : ""}${months > 0 ? ' $months month${months > 1 ? "s" : ""}' : ''} ago';
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      int remainingDays = difference.inDays - (months * 30);
      return '$months month${months > 1 ? "s" : ""}${remainingDays > 0 ? ' $remainingDays day${remainingDays > 1 ? "s" : ""}' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? "s" : ""} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? "s" : ""} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? "s" : ""} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? "s" : ""} ago';
    } else if (difference.inMilliseconds > 0) {
      return '${difference.inMilliseconds} millisecond${difference.inMilliseconds > 1 ? "s" : ""} ago';
    } else if (difference.inMicroseconds > 0) {
      return '${difference.inMicroseconds} microsecond${difference.inMicroseconds > 1 ? "s" : ""} ago';
    } else {
      return 'Just now';
    }
  }
}
