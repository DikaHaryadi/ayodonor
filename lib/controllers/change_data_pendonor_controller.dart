import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/dokter_root_page.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants.dart';

class ChangeDataPendonorController extends GetxController {
  final showProgress = false.obs;
  final errorMsg = ''.obs;

  final nikController = TextEditingController();
  final usernameController = TextEditingController();
  final tempatKelahiranController = TextEditingController();
  final phoneController = TextEditingController();
  final jlnRumahController = TextEditingController();
  final emailController = TextEditingController();
  final provinsiController = TextEditingController();
  final kotaController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kodePosController = TextEditingController();
  final pekerjaanController = TextEditingController();

  final nikFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final tempatKelahiranFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final pekerjaanFocusNode = FocusNode();
  // final emailFocusNode = FocusNode();

  RxString golDarah = RxString('');
  RxString rhesus = RxString('');
  RxString tglKelahiran = RxString('');

  RxString provinsi = RxString('');
  RxString kabAtaukota = RxString('');
  RxString kecamatan = RxString('');

  StorageUtil storage = StorageUtil();

  Future<void> editProfileKhususDokter(String email) async {
    try {
      showProgress.value = true;

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.changeProfileKhususDokter}');
      var request = http.MultipartRequest('POST', uri);
      request.fields['nik'] = nikController.text;
      request.fields['rhesus'] = rhesus.toString();
      request.fields['name'] = usernameController.text;
      request.fields['tgl_lahir'] = tglKelahiran.toString();
      request.fields['tempat_lahir'] = tempatKelahiranController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['email'] = email;
      request.fields['gol_darah'] = golDarah.toString();
      request.fields['provinsi'] = provinsi.toString();
      request.fields['kabAtaukota'] = kabAtaukota.toString();
      request.fields['kecamatan'] = kecamatan.toString();
      request.fields['jln_rumah'] = jlnRumahController.text;
      request.fields['kodepos'] = kodePosController.text;
      request.fields['pekerjaan'] = pekerjaanController.text;

      var streamResponse = await request.send();
      print('req ' + provinsi.toString());
      print('req ' + kabAtaukota.toString());
      print('req ' + kecamatan.toString());
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);
      print(jsondata);

      if (jsondata['success'] == true) {
        showProgress.value = false;
        errorMsg.value = jsondata["message"];
        Get.snackbar('Success', errorMsg.value);
        Get.offAll(() => const DokterRootPage());
      } else {
        showProgress.value = false;
        errorMsg.value = jsondata["message"];
        Get.snackbar('Error', errorMsg.value);
      }
    } catch (error) {
      showProgress.value = false;
      errorMsg.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMsg.value);
    } finally {
      showProgress.value = false;
    }
  }
}
