import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/reusable_text.dart';

class RegistrationController extends GetxController {
  final nikController = TextEditingController();
  final usernameController = TextEditingController();
  final tempatKelahiranController = TextEditingController();
  final phoneController = TextEditingController();
  final instansiBekerjaController = TextEditingController();
  final provinsiController = TextEditingController();
  final kotaController = TextEditingController();
  final kecamatanController = TextEditingController();
  final jlnRumahController = TextEditingController();
  final kodePosController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final nikFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final tempatKelahiranFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final provinsiFc = FocusNode();
  final kabAtaukotaFc = FocusNode();
  final kecamatanFc = FocusNode();
  final kelurahanFc = FocusNode();
  final kodePosFc = FocusNode();
  final pekerjaanFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();

  Rx<File?> image = Rx<File?>(null);

  RxString gender = RxString('');
  RxString puasa = RxString('');
  RxString dibutuhkan = RxString('');
  RxString golDarah = RxString('');
  RxString rhesus = RxString('');
  RxString tglKelahiran = RxString('');

  // RxString instansiBekerja = RxString('');
  RxString provinsi = RxString('');
  RxString kabAtaukota = RxString('');
  RxString kecamatan = RxString('');

  // RxString instansiBekerja = RxString('');

  final showProgress = false.obs;
  final errorMessage = ''.obs;

  void setImage(File? newImage) {
    image.value = newImage;
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setImage(imageTemporary); // Set the image in the reactive state
    } on PlatformException catch (e) {
      Get.snackbar('Gagal mengambil gambar :', '$e');
    }
  }

  Future<void> deleteImage() async {
    if (image.value != null) {
      await image.value!.delete();
      image.value = null;
    }
  }

  Future<void> dialogLocationImg(BuildContext context) async {
    locationDialog({
      required AlignmentGeometry alignment,
      double width = double.infinity,
      double height = double.infinity,
    }) async {
      SmartDialog.show(
        alignment: alignment,
        builder: (_) => Container(
          width: width,
          height: height * 1.7,
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          color: Color(kDark.value).withOpacity(0.4),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ReusableText(
                    text: 'Pilih Foto',
                    style: appstyle(20, Color(kLight.value), FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Color(kDarkGrey.value))),
                          child: Icon(
                            Icons.camera,
                            color: Color(kLight.value),
                          ),
                        ),
                        ReusableText(
                            text: 'Kamera',
                            style: appstyle(14, kLight, FontWeight.normal)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 100),
                  InkWell(
                    onTap: () {
                      image.value != null
                          ? deleteImage()
                          : getImage(ImageSource.gallery);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Color(kDarkGrey.value))),
                          child: Icon(
                            image.value != null ? Icons.delete : Icons.image,
                            color: Color(kLight.value),
                          ),
                        ),
                        ReusableText(
                            text: image.value != null ? 'Hapus' : 'Galeri',
                            style: appstyle(14, kLight, FontWeight.normal)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
      SmartDialog.dismiss();
    }

    await locationDialog(height: 70, alignment: Alignment.bottomCenter);
  }

  Future<void> register() async {
    try {
      showProgress.value = true;

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerURL}');
      var request = http.MultipartRequest('POST', uri);

      request.fields['nik'] = nikController.text;
      request.fields['name'] = usernameController.text;
      request.fields['kelamin'] = gender.toString();
      request.fields['tgl_lahir'] = tglKelahiran.toString();
      request.fields['tempat_lahir'] = tempatKelahiranController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['email'] = emailController.text;
      request.fields['gol_darah'] = golDarah.toString();
      request.fields['rhesus'] = rhesus.toString();
      request.fields['password'] = passController.text;
      request.fields['provinsi'] = provinsi.toString();
      request.fields['kabAtaukota'] = kabAtaukota.toString();
      request.fields['kecamatan'] = kecamatan.toString();
      request.fields['jln_rumah'] = jlnRumahController.text;
      request.fields['kodepos'] = kodePosController.text;
      request.fields['pekerjaan'] = pekerjaanController.text;
      request.fields['donor_puasa'] = puasa.toString();
      request.fields['donor_saat_dibutuhkan'] = dibutuhkan.toString();
      request.fields['status'] = '1';

      if (image.value != null) {
        var pic = await http.MultipartFile.fromPath('img', image.value!.path);
        request.files.add(pic);
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);

      if (jsondata['success'] == true) {
        showProgress.value = false;
        Get.snackbar('Success', 'Berhasil Registrasi');
        Get.offAll(() => const Login());
      } else {
        showProgress.value = false;
        errorMessage.value = jsondata['errors']['email'][0];
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (error) {
      showProgress.value = false;
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      showProgress(false);
    }
  }

  Future<void> registerDokter() async {
    try {
      showProgress.value = true;

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerDokter}');
      var request = http.MultipartRequest('POST', uri);

      // request.fields['role'] = role.toString();
      request.fields['nama_dokter'] = usernameController.text;
      request.fields['instansi_bekerja'] = instansiBekerjaController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['kelamin'] = gender.toString();
      request.fields['email'] = emailController.text;
      request.fields['password'] = passController.text;

      if (image.value != null) {
        var pic = await http.MultipartFile.fromPath('img', image.value!.path);
        request.files.add(pic);
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);

      if (jsondata['success'] == true) {
        showProgress.value = false;
        Get.snackbar('Success', 'Berhasil Registrasi');
        Get.offAll(() => const Login());
      } else {
        showProgress.value = false;
        errorMessage.value = jsondata['msg'];
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (error) {
      showProgress.value = false;
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      showProgress(false);
    }
  }

  Future<void> registerAftap() async {
    try {
      showProgress.value = true;

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerAftap}');
      var request = http.MultipartRequest('POST', uri);

      // request.fields['role'] = role.toString();
      request.fields['id_aftap'] = nikController.text;
      request.fields['nama_aftap'] = usernameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['instansi_bekerja'] = instansiBekerjaController.text;
      request.fields['jln_rumah'] = jlnRumahController.text;
      request.fields['kelamin'] = gender.toString();
      request.fields['email'] = emailController.text;
      request.fields['password'] = passController.text;

      if (image.value != null) {
        var pic = await http.MultipartFile.fromPath('img', image.value!.path);
        request.files.add(pic);
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);

      print('ini register AFTAP jsonData : ' + jsondata.toString());

      if (jsondata['success'] == true) {
        showProgress.value = false;
        print(jsondata);
        Get.snackbar('Success', 'Berhasil Registrasi');
        Get.offAll(() => const Login());
      } else {
        showProgress.value = false;
        errorMessage.value = jsondata['msg'];
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (error) {
      showProgress.value = false;
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value);
      print('ini pesan error register AFTAP' + error.toString());
    } finally {
      showProgress(false);
    }
  }

  @override
  void onClose() {
    nikController.dispose();
    usernameController.dispose();
    tempatKelahiranController.dispose();
    phoneController.dispose();
    // provinsiController.dispose();
    // kabAtaukotaController.dispose();
    // kecamatanController.dispose();
    kodePosController.dispose();
    pekerjaanController.dispose();
    emailController.dispose();
    passController.dispose();

    super.onClose();
  }
}
