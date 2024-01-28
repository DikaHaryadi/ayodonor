import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getdonor/controllers/aftap_controller.dart';
import 'package:getdonor/model/data_pendonor_model.dart';
import 'package:getdonor/pages/edit_profile.dart';
import 'package:getdonor/pages/forgot_pw.dart';
import 'package:getdonor/pages/pemeriksaan_pendonor.dart';
import 'package:http/http.dart' as http;

import '../model/pemeriksaan_dokter.dart';
import '../pages/change_data_pendonor.dart';
import '../utils/app_constants.dart';
import '../utils/components/storage_util.dart';
// import '../utils/components/storage_util.dart';

class CheckNikController extends GetxController {
  final showProgress = false.obs;
  final errorMsg = ''.obs;
  DataPendonorModel dataPendonorModel = DataPendonorModel();
  PemeriksaanDokter pemeriksaanDokterModel = PemeriksaanDokter();
  AftapController aftapController = Get.put(AftapController());

  final dataPendonorList = <DataPendonorModel>[].obs;
  final dataPemeriksaanList = <PemeriksaanDokter>[].obs;

  final StorageUtil _storageUtil = StorageUtil();

  final prefs = GetStorage();

  Future<void> checkNik(String nik) async {
    try {
      showProgress.value = true;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checkNik}'),
        body: {'nik': nik},
      );

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        if (jsondata["success"] == false) {
          errorMsg.value = jsondata["msg"];
          Get.snackbar('Peringatan :', errorMsg.value);
        } else {
          errorMsg.value = jsondata["msg"];
          await prefs.write('forgot_email', jsondata["email"] ?? '');
          Get.snackbar('Berhasil :', errorMsg.value);

          Get.to(() => const ForgotPw());
        }
      } else {
        errorMsg.value = "Kesalahan saat menghubungkan ke server.";
        Get.snackbar('Error :', errorMsg.value);
      }
    } finally {
      showProgress.value = false;
    }
  }

  Future<void> checkNikKhususDokter(String nik) async {
    try {
      showProgress.value = true;
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getPendonorData}?nik=$nik'));

      print(response.body.toString());
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        dataPendonorList.assignAll(jsonResponse
            .map((data) => DataPendonorModel.fromJson(data))
            .toList());

        Get.to(() => ChangeDataPendonor2(
              nik: nik,
            ));
      } else {
        throw Exception('Gagal mengambil data pendonor');
      }
    } catch (e) {
      print('Error : $e');
    } finally {
      showProgress.value = false;
    }
  }

  Future<void> checkNikPemeriksaan(String nik) async {
    try {
      showProgress.value = true;
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getPendonorData}?nik=$nik'));

      print(response.body.toString());
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        dataPendonorList.assignAll(jsonResponse
            .map((data) => DataPendonorModel.fromJson(data))
            .toList());

        Get.to(() => PemeriksaanPendonor(
              nik: nik,
            ));
      } else {
        throw Exception('Gagal mengambil data pendonor');
      }
    } catch (e) {
      print('Error : $e');
    } finally {
      showProgress.value = false;
    }
  }

  // Future<void> selectByIdAftap(int aftapId) async {
  //   try {
  //     showProgress.value = true;
  //     final response = await http.get(Uri.parse(
  //         '${ApiConstants.baseUrl}${ApiConstants.getPemeriksaanPendonor}/$aftapId'));
  //     print('ini response nya : ${response.toString()}');

  //     if (response.statusCode == 200) {}
  //   } catch (e) {
  //     print('Error : $e');
  //   } finally {
  //     showProgress.value = false;
  //   }
  // }

  Future<void> checkNikChangeProfile(String nik) async {
    try {
      showProgress.value = true;

      final loggedInUserNik = _storageUtil.getNik();

      if (loggedInUserNik == nik) {
        final response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checkNik}'),
          body: {'nik': nik},
        );

        if (response.statusCode == 200) {
          final jsondata = json.decode(response.body);

          if (jsondata["success"] == false) {
            errorMsg.value = jsondata["msg"];
            Get.snackbar('Peringatan :', errorMsg.value);
          } else {
            errorMsg.value = jsondata["msg"];
            await prefs.write('forgot_email', jsondata["email"] ?? '');
            Get.snackbar('Berhasil :', errorMsg.value);

            Get.to(() => const EditProfile());
          }
        } else {
          errorMsg.value = "Kesalahan saat menghubungkan ke server.";
          Get.snackbar('Error :', errorMsg.value);
        }
      } else {
        showProgress.value = false;
        Get.snackbar('Error',
            'Nomor Induk Kependudukan yang Anda masukkan tidak sesuai dengan NIK pada akun Anda.');
      }
    } finally {
      showProgress.value = false;
    }
  }
}
