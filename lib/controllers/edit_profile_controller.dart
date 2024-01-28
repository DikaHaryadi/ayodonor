import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../pages/login.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/reusable_text.dart';

class EditProfileController extends GetxController {
  final showProgress = false.obs;
  final errorMsg = ''.obs;

  RxString golDarah = RxString('');
  RxString rhesus = RxString('');
  Rx<File?> image = Rx<File?>(null);
  // late bool isEdit;

  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final jlnRumahController = TextEditingController();
  final pekerjaanController = TextEditingController();

  final usernameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final alamatFocusNode = FocusNode();
  final pekerjaanFocusNode = FocusNode();

  StorageUtil storage = StorageUtil();

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

  Future<void> editProfile() async {
    String email = storage.getForgotEmail();
    try {
      showProgress.value = true;

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changeProfile}');
      var request = http.MultipartRequest('POST', uri);
      request.fields['email'] = email;
      request.fields['name'] = usernameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['gol_darah'] = golDarah.toString();
      request.fields['rhesus'] = rhesus.toString();
      request.fields['jln_rumah'] = jlnRumahController.text;
      request.fields['pekerjaan'] = pekerjaanController.text;

      if (image.value != null) {
        var pic = await http.MultipartFile.fromPath('img', image.value!.path);
        request.files.add(pic);
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);

      if (jsondata['success'] == true) {
        showProgress.value = false;
        errorMsg.value = jsondata["message"];
        Get.snackbar('Success', errorMsg.value);
        storage.logout();
        Get.offAll(() => const Login());
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

  @override
  void onInit() {
    // isEdit = false;
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    phoneController.dispose();
    jlnRumahController.dispose();
    pekerjaanController.dispose();

    usernameFocusNode.dispose();
    phoneFocusNode.dispose();
    alamatFocusNode.dispose();
    pekerjaanFocusNode.dispose();

    super.onClose();
  }
}
