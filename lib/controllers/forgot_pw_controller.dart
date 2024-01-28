import 'dart:convert';

import 'package:get/get.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants.dart';

class ForgotPwController extends GetxController {
  StorageUtil storage = StorageUtil();
  final showProgress = false.obs;
  final errorMsg = ''.obs;

  Future<void> forgotPw(String password, String confirmPassword) async {
    String email = storage.getForgotEmail();
    try {
      showProgress.value = true;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.forgotPassword}'),
        body: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword
        },
      );

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        if (jsondata["success"] == false) {
          errorMsg.value = jsondata["message"];
          Get.snackbar('Peringatan :', errorMsg.value);
        } else {
          errorMsg.value = jsondata["message"];
          Get.snackbar('Berhasil :', errorMsg.value);

          Get.to(() => const Login());
        }
      } else if (response.statusCode == 400) {
        final jsondata = json.decode(response.body);

        if (jsondata["success"] == false) {
          //ambil error message
          errorMsg.value = jsondata["message"];
          Get.snackbar('Peringatan :', errorMsg.value);
        }
      } else {
        errorMsg.value = "Kesalahan saat menghubungkan ke server.";
        Get.snackbar('Error :', errorMsg.value);
      }
    } finally {
      showProgress.value = false;
    }
  }
}
