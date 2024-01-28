import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/model/pemeriksaan_model.dart';
import 'package:getdonor/pages/aftap_root_page.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../utils/components/storage_util.dart';

class AftapController extends GetxController {
  var isLoading = false.obs;
  final errorMessage = ''.obs;
  final StorageUtil storage = StorageUtil();
  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
  PemeriksaanModel pemeriksaanModel = PemeriksaanModel();

  final pemeriksaanModelList = <PemeriksaanModel>[].obs;
  final pemeriksaanModelDitolakList = <PemeriksaanModel>[].obs;
  final pemeriksaanModelDiterimaList = <PemeriksaanModel>[].obs;

  TextEditingController nikController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController instansiController = TextEditingController();

  RxString tglPengambilanDarah = RxString(''); //
  RxString golDarah = RxString('');
  RxString rhesus = RxString('');

  @override
  Future<void> onInit() async {
    fetchDataPemeriksaan(storage.getInstansiBekerja(), '1');
    fetchDataPemeriksaanDitolak(storage.getInstansiBekerja());
    fetchDataPemeriksaanDiterima(storage.getInstansiBekerja());
    super.onInit();
  }

  fetchDataPemeriksaan(String instansi, String status) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDonePemeriksaan}?instansi=$instansi&status=$status'));

      print(response.body.toString());

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        pemeriksaanModelList.assignAll(jsonResponse
            .map((data) => PemeriksaanModel.fromJson(data))
            .toList());
      } else {
        throw Exception('Gagal mengambil data pendonor');
      }
    } catch (e) {
      // Handle error as needed
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  fetchDataPemeriksaanDitolak(String instansi) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDonePemeriksaan}?instansi=$instansi&status=0'));

      print(response.body.toString());

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        pemeriksaanModelDitolakList.assignAll(jsonResponse
            .map((data) => PemeriksaanModel.fromJson(data))
            .toList());
      } else {
        throw Exception('Gagal mengambil data pendonor');
      }
    } catch (e) {
      // Handle error as needed
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  fetchDataPemeriksaanDiterima(String instansi) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDonePemeriksaan}?instansi=$instansi&status=2'));

      print(response.body.toString());

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        pemeriksaanModelDiterimaList.assignAll(jsonResponse
            .map((data) => PemeriksaanModel.fromJson(data))
            .toList());
      } else {
        throw Exception('Gagal mengambil data pendonor');
      }
    } catch (e) {
      // Handle error as needed
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> postPengambilanDarah() async {
    try {
      isLoading.value = true;

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.postPengambilanDarah}');
      var request = http.MultipartRequest('POST', uri);

      print('ini request nya : ${request.toString()}');

      request.fields['tgl_pengambilan'] = tglPengambilanDarah.toString();
      request.fields['nik_pendonor'] = nikController.text;
      request.fields['nama_pendonor'] = usernameController.text;
      request.fields['gol_darah'] = golDarah.toString();
      request.fields['rhesus'] = rhesus.toString();
      request.fields['nama_instansi'] = instansiController.text;

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print('response nya ini : ${response.toString()}');

      var jsondata = json.decode(response.body);
      print('ini jsonData nya :${jsondata.toString()}');

      if (jsondata[0]['success'] == true) {
        isLoading.value = false;
        errorMessage.value = jsondata[0]["msg"];
        print(errorMessage.value);
        Get.snackbar('Success', errorMessage.value);
        Get.offAll(() => const AftapRootPage());
      } else {
        isLoading.value = false;
        errorMessage.value = jsondata[0]["msg"];
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (err) {
      isLoading.value = false;
      errorMessage.value = err.toString();
      Get.snackbar('Error', errorMessage.value);
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
