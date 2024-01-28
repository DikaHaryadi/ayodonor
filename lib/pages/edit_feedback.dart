import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/post_feedback_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/feedback_model.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/feedback_controller.dart';
import '../utils/Custom/custom_loading.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/debouncer.dart';

class EditFeedbackPage extends StatefulWidget {
  final FeedBackModel feedBackModel;
  const EditFeedbackPage({super.key, required this.feedBackModel});

  @override
  _EditFeedbackPageState createState() => _EditFeedbackPageState();
}

class _EditFeedbackPageState extends State<EditFeedbackPage> {
  PostFeedBackController postFeedBackController =
      Get.put(PostFeedBackController());
  FeedBackController feedBackController = Get.put(FeedBackController());
  StorageUtil storage = StorageUtil();
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  ThemeController themeController = Get.put(ThemeController());

  bool? textVisible = true;

  @override
  void initState() {
    textVisible = true;
    postFeedBackController.editpostingController.text =
        widget.feedBackModel.deskripsi!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: Get.overlayContext!,
          builder: (context) => AlertDialog(
            title: const Text(
              'Perubahan belum disimpan',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            content: ReusableText(
                text: 'Perubahan yang Anda buat tidak akan disimpan',
                maxlines: 2,
                style: appstyle(14, null, FontWeight.normal)),
            actions: [
              TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Terus Mengedit')),
              TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Hapus')),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 45,
            shadowColor: Color(kLightGrey.value),
            leading: IconButton(
                onPressed: () async {
                  await showDialog(
                    context: Get.overlayContext!,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Perubahan belum disimpan',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      content: ReusableText(
                          text: 'Perubahan yang Anda buat tidak akan disimpan',
                          maxlines: 2,
                          style: appstyle(14, null, FontWeight.normal)),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Terus Mengedit')),
                        TextButton(
                            onPressed: () {
                              postFeedBackController
                                  .editpostingController.text = '';
                              postFeedBackController.deleteImage();
                              Get.to(() => const RootPage());
                            },
                            child: const Text('Hapus')),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                )),
            title: ReusableText(
                text: 'Edit Postingan',
                style: appstyle(
                    16,
                    themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kDark.value),
                    FontWeight.w500)),
            actions: [
              GestureDetector(onTap: () async {
                if (textVisible == true &&
                    postFeedBackController.image.value == null) {
                  return;
                } else if (postFeedBackController.image.value != null) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard

                  SmartDialog.showLoading(
                    animationType: SmartAnimationType.scale,
                    builder: (_) => const CustomLoading(),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  // Call postFeedBack method
                  debouncer(
                    () async {
                      int feedbackId = widget.feedBackModel.id!;

                      await postFeedBackController.editFeedBack(feedbackId);
                    },
                  );
                  SmartDialog.dismiss();
                } else {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard

                  SmartDialog.showLoading(
                    animationType: SmartAnimationType.scale,
                    builder: (_) => const CustomLoading(),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  // Call postFeedBack method
                  debouncer(
                    () async {
                      int feedbackId = widget.feedBackModel.id!;

                      // Call the editFeedback function with the new data
                      await postFeedBackController.editFeedBack(feedbackId);
                    },
                  );

                  SmartDialog.dismiss();
                }
              }, child: Obx(
                () {
                  return postFeedBackController.image.value != null
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: ReusableText(
                              text: 'SIMPAN',
                              style: appstyle(
                                  15, Color(kLight.value), FontWeight.bold)),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: textVisible! &&
                                    postFeedBackController.image.value == null
                                ? themeController.isDarkTheme()
                                    ? const Color(0xff8a8d92).withOpacity(0.6)
                                    : const Color(0xff8a8d92).withOpacity(0.4)
                                : Colors.blue,
                          ),
                          child: ReusableText(
                              text: 'SIMPAN',
                              style: appstyle(
                                  15,
                                  textVisible! &&
                                          postFeedBackController.image.value ==
                                              null
                                      ? themeController.isDarkTheme()
                                          ? Color(kLight.value).withOpacity(0.6)
                                          : Color(kLight.value).withOpacity(0.5)
                                      : Color(kLight.value),
                                  FontWeight.bold)),
                        );
                },
              )),
            ]),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: postFeedBackController.editpostingController,
                keyboardType: TextInputType.text,
                maxLines: 10,
                minLines: 1,
                style: TextStyle(
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                ),
                onChanged: (value) {
                  setState(() {
                    postFeedBackController.editpostingController.text == ''
                        ? textVisible = true
                        : textVisible = false;
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: appstyle(
                        16,
                        themeController.isDarkTheme()
                            ? Color(kLightGrey.value)
                            : Color(kDarkGrey.value),
                        FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (postFeedBackController.image.value == null) {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.transparent,
                      child: Image.network(
                        ApiUtils.getShearPreferenceImg(
                            widget.feedBackModel.img!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            postFeedBackController.dialogLocationImg(context);
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.green.shade200,
                          ),
                        ))
                  ],
                );
              } else {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.transparent,
                      child: Image.file(
                        postFeedBackController.image.value!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 10,
                        child: IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: Get.overlayContext!,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Perubahan belum disimpan',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                content: ReusableText(
                                    text: 'Foto ini akan anda hapus',
                                    maxlines: 2,
                                    style:
                                        appstyle(14, null, FontWeight.normal)),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: const Text('Terus Mengedit')),
                                  TextButton(
                                      onPressed: () {
                                        postFeedBackController.deleteImage();
                                        Get.back(result: true);
                                      },
                                      child: const Text('Hapus')),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Ionicons.trash,
                            color: Color(kRed.value),
                          ),
                        ))
                  ],
                );
              }
            }),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  style: BorderStyle.solid,
                  color: themeController.isDarkTheme()
                      ? Color(kLightGrey.value)
                      : Color(kDarkGrey.value).withOpacity(.4))),
          child: BottomNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: () {
                      postFeedBackController.getImage(ImageSource.gallery);
                    },
                    child: const Icon(
                      Ionicons.image,
                      color: Color(0xff45bd63),
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: () {
                      postFeedBackController.getImage(ImageSource.camera);
                    },
                    child: const Icon(
                      Ionicons.camera,
                      color: Color(0xff4699ff),
                    ),
                  ),
                  label: '',
                ),
              ]),
        ),
      ),
    );
  }
}
