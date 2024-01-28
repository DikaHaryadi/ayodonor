import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../pages/aftap_root_page.dart';
import '../pages/dokter_root_page.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final showProgress = false.obs;
  final error = false.obs;
  final errorMsg = ''.obs;

  final prefs = GetStorage();

  Future<void> login() async {
    try {
      showProgress.value = true;
      error.value = false;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginURL}'),
        body: {'email': emailController.text, 'password': passController.text},
      );

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        if (jsondata["success"] == false) {
          error.value = true;
          errorMsg.value = jsondata["message"];
          Get.snackbar('Tidak dapat masuk :', errorMsg.value);
        } else {
          await prefs.write('roles', '0');
          await prefs.write('status', '1');
          await prefs.write('name', jsondata['data'][0]["name"]);
          await prefs.write('login', 'True');
          await prefs.write('email', jsondata['data'][0]["email"]);
          await prefs.write('pekerjaan', jsondata['data'][0]["pekerjaan"]);
          await prefs.write('jln_rumah', jsondata['data'][0]["jln_rumah"]);
          // print('ini jalan rumahnya : ${jsondata['data'][0]["jln_rumah"]}');
          await prefs.write(
              'gol_darah', jsondata['data'][0]["gol_darah"] ?? '');
          await prefs.write('rhesus', jsondata['data'][0]["rhesus"] ?? '');
          await prefs.write('phone', jsondata['data'][0]["phone"] ?? '');
          await prefs.write('nik', jsondata['data'][0]["nik"] ?? '');
          await prefs.write('img', jsondata['data'][0]["img"] ?? '');
          await prefs.write('provinsi', jsondata['data'][0]["provinsi"] ?? '');
          await prefs.write(
              'kabAtaukota', jsondata['data'][0]["kabAtaukota"] ?? '');
          await prefs.write(
              'kecamatan', jsondata['data'][0]["kecamatan"] ?? '');
          // storage.roles == pendonor ? RootPage() : storage.roles == dokter ? DokterPage() : AFTAPPage()
          Get.offAll(() => const RootPage());
        }
      } else {
        error.value = true;
        errorMsg.value = "Kesalahan saat menghubungkan ke server.";
        Get.snackbar('Error :', errorMsg.value);
      }
    } finally {
      showProgress.value = false;
    }
  }

  Future<void> loginDokter() async {
    try {
      showProgress.value = true;
      error.value = false;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginDokter}'),
        body: {'email': emailController.text, 'password': passController.text},
      );

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        if (jsondata["success"] == false) {
          error.value = true;
          errorMsg.value = jsondata["msg"];
          Get.snackbar('Tidak dapat masuk :', errorMsg.value);
        } else {
          await prefs.write('roles', '1');
          await prefs.write('nama_dokter', jsondata['data'][0]["nama_dokter"]);
          await prefs.write(
              'instansi_bekerja', jsondata['data'][0]["instansi_bekerja"]);
          await prefs.write('login', 'True');
          await prefs.write('email', jsondata['data'][0]["email"]);
          await prefs.write('phone', jsondata['data'][0]["phone"] ?? '');
          await prefs.write('kelamin', jsondata['data'][0]["kelamin"] ?? '');
          await prefs.write('img', jsondata['data'][0]["img"] ?? '');
          // storage.roles == pendonor ? RootPage() : storage.roles == dokter ? DokterPage() : AFTAPPage()
          Get.offAll(() => const DokterRootPage());
        }
      } else {
        error.value = true;
        errorMsg.value = "Kesalahan saat menghubungkan ke server.";
        Get.snackbar('Error :', errorMsg.value);
      }
    } finally {
      showProgress.value = false;
    }
  }

  Future<void> loginAftap() async {
    try {
      showProgress.value = true;
      error.value = false;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginAftap}'),
        body: {'email': emailController.text, 'password': passController.text},
      );

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        print('ini jsonData dokter login' + jsondata.toString());

        if (jsondata["success"] == false) {
          error.value = true;
          errorMsg.value = jsondata["msg"];
          Get.snackbar('Tidak dapat masuk :', errorMsg.value);
        } else {
          await prefs.write('roles', '2');
          await prefs.write('id_aftap', jsondata['data'][0]["id_aftap"]);
          await prefs.write('nama_aftap', jsondata['data'][0]["nama_aftap"]);
          await prefs.write(
              'instansi_bekerja', jsondata['data'][0]["instansi_bekerja"]);
          await prefs.write('kelamin', jsondata['data'][0]["kelamin"]);
          await prefs.write('login', 'True');
          await prefs.write('email', jsondata['data'][0]["email"]);
          await prefs.write('phone', jsondata['data'][0]["phone"] ?? '');
          await prefs.write('img', jsondata['data'][0]["img"] ?? '');
          // storage.roles == pendonor ? RootPage() : storage.roles == dokter ? DokterPage() : AFTAPPage()
          Get.offAll(() => const AftapRootPage());
        }
      } else {
        error.value = true;
        errorMsg.value = "Kesalahan saat menghubungkan ke server.";
        Get.snackbar('Error :', errorMsg.value);
      }
    } finally {
      showProgress.value = false;
    }
  }
}
