import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/daftar_donor_controller.dart';
import 'package:getdonor/model/daftar_donor_model.dart';
import 'package:getdonor/model/pemeriksaan_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../pages/dokter_root_page.dart';
import '../utils/app_constants.dart';
import '../utils/components/storage_util.dart';

class PemeriksaanController extends GetxController {
  DaftarDonorController daftarDonorController =
      Get.put(DaftarDonorController());
  final StorageUtil storage = StorageUtil();

  var isLoading = false.obs;
  final errorMessage = ''.obs;

  final pemeriksaanList = <PemeriksaanModel>[].obs;
  final daftarDonorList = <DaftarDonorModel>[].obs;
  final daftarDonorDoneList = <DaftarDonorModel>[].obs;
  PemeriksaanModel? pemeriksaanModel;

  final instansiController = TextEditingController(); // gaada ditampilin
  final usernameController = TextEditingController();
  final nikController = TextEditingController();
  final beratBadanController = TextEditingController(); // gaada ditampilin
  final tinggiBadanController = TextEditingController(); // gaada ditampilin
  final asamUratController = TextEditingController(); // gaada ditampilin
  final tekananDarahController = TextEditingController(); // gaada ditampilin
  final systolicController = TextEditingController(); // gaada ditampilin
  final diastolicController = TextEditingController(); // gaada ditampilin
  final pulseController = TextEditingController(); // gaada ditampilin
  final heartRateController = TextEditingController(); // gaada ditampilin

  RxString gula = RxString(''); // gaada ditampilin
  RxString kolesterol = RxString(''); // gaada ditampilin
  RxString tglPemeriksaan = RxString(''); // gaada ditampilin
  RxString rhesus = RxString('');
  RxString golDarah = RxString('');
  RxString status = RxString(''); // gaada ditampilin

  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
  @override
  void onInit() {
    fetchFilterPendaftaranPendonoran(storage.getInstansiBekerja());
    fetchFilterPendonoranDone('1');
    super.onInit();
  }

  Future<void> fetchPemeriksaan(String nik) async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          '${ApiConstants.baseUrl}${ApiConstants.pemeriksaan}?nik=$nik')!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as List;
        pemeriksaanList
            .assignAll(result.map((json) => PemeriksaanModel.fromJson(json)));

        // Set pemeriksaanModel to the first item if available
        if (pemeriksaanList.isNotEmpty) {
          pemeriksaanModel = pemeriksaanList[0];
          update();
        } else {
          // Handle the case where no data is available
          pemeriksaanModel = null;
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

  Future<void> postPemeriksaanDokter() async {
    final namaDokter = storage.getNameDokter();
    try {
      isLoading.value = true;
      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getPemeriksaan}');
      var request = http.MultipartRequest('POST', uri);

      print('ini request nya : $request');

      request.fields['instansi'] = instansiController.text;
      // request.fields['id_prov'] = instansiController.text;
      request.fields['user_id'] = usernameController.text;
      request.fields['nik'] = nikController.text;
      request.fields['gula'] = gula.toString();
      request.fields['kolesterol'] = kolesterol.toString();
      request.fields['berat_badan'] = beratBadanController.text;
      request.fields['tinggi_badan'] = tinggiBadanController.text;
      request.fields['asam_urat'] = asamUratController.text;
      request.fields['tekanan_darah'] = tekananDarahController.text;
      request.fields['tgl'] = tglPemeriksaan.toString();
      request.fields['systolic'] = systolicController.text;
      request.fields['diastolic'] = diastolicController.text;
      request.fields['pulse'] = pulseController.text;
      request.fields['heart_rate'] = heartRateController.text;
      request.fields['resus'] = rhesus.toString();
      request.fields['gol_darah'] = golDarah.toString();
      request.fields['status'] = status.toString();
      request.fields['nama_dokter'] = namaDokter;

      print(
          'gula: $gula, kolesterol: $kolesterol, tglPemeriksaan: $tglPemeriksaan, rhesus: $rhesus, golDarah: $golDarah, status: $status');
      print(
          'user_id ${usernameController.text} nik ${nikController.text} bb ${beratBadanController.text} tinggi_bd ${tinggiBadanController.text} asam_urat ${asamUratController.text}');
      print(
          'tekanan_darah ${tekananDarahController.text} systolic ${systolicController.text} diastolic ${diastolicController.text} pulse ${pulseController.text} heart_rate ${heartRateController.text}');

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print('response nya ini : ${response.body.toString()}');

      var jsondata = json.decode(response.body);
      print('ini jsonData nya :${jsondata.toString()}');

      if (jsondata[0]['success'] = true) {
        isLoading.value = false;
        errorMessage.value = jsondata[0]["msg"];
        print(errorMessage.value);
        Get.snackbar('Success', errorMessage.value);
        Get.offAll(() => const DokterRootPage());
      } else {
        isLoading.value = false;
        errorMessage.value = jsondata[0]["msg"];
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (err) {
      isLoading.value = false;
      errorMessage.value = err.toString();
      Get.snackbar('Error', errorMessage.value);
      print('Error catch' + errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFilterPendaftaranPendonoran(String instansi) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDaftarDarahDokter}?nama_instansi=$instansi&status=0'));

      print(response.body.toString());

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        daftarDonorList.assignAll(jsonResponse
            .map((data) => DaftarDonorModel.fromJson(data))
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

  Future<void> fetchFilterPendonoranDone(String status) async {
    var instansi = storage.getInstansiBekerja();
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDaftarDarahDokter}?status=$status&nama_instansi=$instansi'));

      print(response.body.toString());

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        daftarDonorDoneList.assignAll(jsonResponse
            .map((data) => DaftarDonorModel.fromJson(data))
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

  // Future<void> fetchDokterPemeriksaan(String instansi) async {
  //   try {
  //     isLoading(true);

  //     PemeriksaanModel feedbackToEdit = feedBackController.feedbackList.firstWhere(
  //       (feedback) => feedback.id == feedbackId,
  //       orElse: () => PemeriksaanModel(),
  //     );

  //     if (feedbackToEdit.id == null) {
  //       showProgress.value = false;
  //       Get.snackbar('Error', 'Feedback not found');
  //       return;
  //     }
  //     http.Response response = await http.get(Uri.tryParse(
  //         '${ApiConstants.baseUrl}${ApiConstants.pemeriksaanDokter}?instansi=$instansi')!);
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body) as List;
  //       print(result);
  //       pemeriksaanList
  //           .assignAll(result.map((json) => PemeriksaanModel.fromJson(json)));

  //       // Set pemeriksaanModel to the first item if available
  //       if (pemeriksaanList.isNotEmpty) {
  //         pemeriksaanModel = pemeriksaanList[0];
  //         update();

  //       } else {
  //         // Handle the case where no data is available
  //         pemeriksaanModel = null;
  //       }
  //     } else {
  //       Get.snackbar('Warning!',
  //           'Kesalahan dalam mengambil data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Warning!', 'Terjadi Error Ketika Mengambil Data: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
