import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/success_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DaftarDonorController extends GetxController {
  String? nik;
  String? namaInstansi;
  String? idProv;
  String? lokasiDonor;
  String? tanggalDonor;
  String? waktuDimulai;
  String? waktuBerakhir;

  DaftarDonorController({
    this.nik,
    this.namaInstansi,
    this.idProv,
    this.lokasiDonor,
    this.tanggalDonor,
    this.waktuDimulai,
    this.waktuBerakhir,
  }) {
    setTanggalDaftar(); //ini construktor juga buat dapetin DateTime.now()
  }

  bool showloading = false;

  RxString tglDaftar = RxString('');
  // RxString tanggalDonor = RxString('');
  // TextEditingController namaInstansi2 = TextEditingController();

  late bool progressDaftar;
  late bool error;

  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
  final timeFormat = DateFormat.Hm();

  @override
  void onInit() {
    error = false;
    progressDaftar = false;
    // namaInstansi2.text = namaInstansi.toString();
    // Future.delayed(const Duration(seconds: 3), () {
    // showloading = false;
    // update(); // Notify the UI that showloading has changed
    // });
    super.onInit();
  }

  void setTanggalDaftar() {
    tglDaftar.value = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  }

  Future<void> register() async {
    try {
      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDaftarDarah}');
      final response = await http.post(
        uri,
        body: {
          'nik': nik,
          'nama_instansi': namaInstansi,
          'id_prov': idProv,
          'lokasi': lokasiDonor,
          'tgl_daftar': tglDaftar.value,
          'tgl_donor': tanggalDonor,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["success"] == true) {
          await showDialogAndNavigate(
            title: 'Pendaftaran Berhasil',
            subtitle:
                '$namaInstansi.\n$lokasiDonor.\n${timeFormat.format(timeFormat.parse(waktuDimulai!))} s/d ${timeFormat.format(timeFormat.parse(waktuBerakhir!))}',
          );
        } else {
          Get.snackbar('Warning!',
              'Kesalahan dalam mengambil data. Message: ${jsonData["msg"]}');
        }
      } else {
        Get.snackbar(
            'Warning!', 'Terjadi error pada server: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Warning!', 'Terjadi error pada server: $e');
    }
  }

  Future<void> showDialogAndNavigate(
      {required String title, required String subtitle}) async {
    await Future.delayed(const Duration(seconds: 2));
    error = false;
    progressDaftar = false;
    update(); // Notify the UI that error and progressDaftar have changed
    Get.generalDialog(
      barrierDismissible: false,
      barrierLabel: "Pendaftaran Donor Darah",
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => Center(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SuccessDialog(
                title: title,
                subtitle: subtitle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
