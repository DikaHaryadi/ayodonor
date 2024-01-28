import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/feedback_controller.dart';
import 'package:getdonor/model/feedback_model.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';

class PostFeedBackController extends GetxController {
  final StorageUtil _storageUtil = StorageUtil();
  final postingController = TextEditingController();
  final editpostingController = TextEditingController();
  FeedBackController feedBackController = Get.put(FeedBackController());

  final showProgress = false.obs;
  final errorMessage = ''.obs;

  Rx<File?> image = Rx<File?>(null);

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

  Future<void> postFeedBack() async {
    try {
      showProgress.value = true;

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postFeedBack}');

      var request = http.MultipartRequest('POST', uri);

      final name = _storageUtil.getName();
      final nik = _storageUtil.getNik();
      // final email = _storageUtil.getStatus() == '1'
      //     ? _storageUtil.getEmail()
      //     : _storageUtil.getStatus() == '2'
      //         ? _storageUtil.getemailGoogle()
      //         : _storageUtil.getEmailFb();
      final goldarah = _storageUtil.getGolDarah();
      final img = _storageUtil.getStatus() == '1'
          ? _storageUtil.getImg()
          : _storageUtil.getStatus() == '2'
              ? _storageUtil.getImgGoogle()
              : _storageUtil.getImgFb();

      request.fields['user'] = name;
      request.fields['nik'] = nik;
      request.fields['gol_darah'] = goldarah;
      request.fields['img_user'] = img;
      request.fields['deskripsi'] = postingController.text;
      request.fields['status'] = _storageUtil.getStatus();

      if (image.value != null) {
        var pic = await http.MultipartFile.fromPath('img', image.value!.path);
        request.files.add(pic);
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsondata = json.decode(response.body);

      if (jsondata[0]["success"] == true) {
        print(jsondata);
        showProgress.value = false;
        Get.snackbar('Success :', 'Postingan Terkirim');
      } else {
        showProgress.value = false;
        errorMessage.value = jsondata['msg'];
        Get.snackbar('Error :', errorMessage.value);
        print(errorMessage.value);
      }
    } catch (err) {
      showProgress.value = false;
      print(err.toString());
      errorMessage.value = 'Terjadi kesalahan ' + err.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      showProgress(false);
    }
  }

  Future<void> deleteFeedback(int feedbackId) async {
    try {
      showProgress.value = true;

      await feedBackController.fetchData();

      FeedBackModel feedbackToDelete = feedBackController.feedbackList
          .firstWhere((feedback) => feedback.id == feedbackId,
              orElse: () => FeedBackModel());

      if (feedbackToDelete.id == null) {
        showProgress.value = false;
        Get.snackbar('Error', 'Feedback not found');
        return;
      }

      // Check if the logged-in user's email matches the author's email
      final loggedInUserNik =
          _storageUtil.getNik(); // Get the logged-in user's email

      if (loggedInUserNik == feedbackToDelete.nik) {
        // User is authorized to delete the feedback
        final baseUrl = Uri.parse(ApiConstants.baseUrl);
        final deleteUrl = baseUrl.replace(path: 'api/feedback/$feedbackId');

        final response = await http.delete(deleteUrl);

        if (response.statusCode == 200) {
          // Delete the feedback from the local list
          feedBackController.feedbackList.remove(feedbackToDelete);

          showProgress.value = false;
          Get.snackbar('Success', 'Feedback deleted successfully');
        } else {
          showProgress.value = false;
          errorMessage.value = 'Failed to delete feedback';
          Get.snackbar('Error', errorMessage.value);
        }
      } else {
        // User is not authorized to delete this post
        showProgress.value = false;
        Get.snackbar('Error', 'You are not authorized to delete this post');
      }
    } catch (err) {
      showProgress.value = false;
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      showProgress.value = false;
    }
  }

  Future<void> editFeedBack(
    int feedbackId,
  ) async {
    try {
      showProgress.value = true;

      await feedBackController.fetchData();

      FeedBackModel feedbackToEdit = feedBackController.feedbackList.firstWhere(
        (feedback) => feedback.id == feedbackId,
        orElse: () => FeedBackModel(),
      );

      if (feedbackToEdit.id == null) {
        showProgress.value = false;
        Get.snackbar('Error', 'Feedback not found');
        return;
      }

      final loggedInUserNik = _storageUtil.getNik();

      if (loggedInUserNik == feedbackToEdit.nik) {
        final uri =
            Uri.parse('${ApiConstants.baseUrl}editfeedback/$feedbackId');
        var request = http.MultipartRequest('POST', uri);
        print(request.toString());

        request.fields['deskripsi'] = editpostingController.text;

        if (image.value != null) {
          var pic = await http.MultipartFile.fromPath('img', image.value!.path);
          request.files.add(pic);
        }

        var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        var jsondata = json.decode(response.body);

        if (jsondata['success'] == true) {
          showProgress.value = false;
          errorMessage.value = jsondata["message"];
          Get.snackbar('Success', errorMessage.value);
          Get.offAll(() => const RootPage());
        } else {
          showProgress.value = false;
          errorMessage.value = jsondata["message"];
          Get.snackbar('Error', errorMessage.value);
        }
      } else {
        showProgress.value = false;
        Get.snackbar('Error', 'You are not authorized to edit this post');
      }
    } catch (e) {
      // Handle specific error types if needed
      showProgress.value = false;
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      showProgress(false);
    }
  }
}
