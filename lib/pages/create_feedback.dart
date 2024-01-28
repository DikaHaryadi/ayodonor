import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/post_feedback_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/Custom/custom_loading.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class CreateFeedBack extends StatefulWidget {
  const CreateFeedBack({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateFeedBack> createState() => _CreateFeedBackState();
}

class _CreateFeedBackState extends State<CreateFeedBack> {
  final PostFeedBackController postFeedBack = Get.put(PostFeedBackController());
  final ThemeController themeController = Get.find();
  final StorageUtil storage = StorageUtil();
  bool? textVisible = true;
  @override
  void initState() {
    textVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer = Debouncer(
      delay: const Duration(milliseconds: 300),
    );
    var width = Get.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 45,
          shadowColor: Color(kLightGrey.value),
          leading: IconButton(
              onPressed: () async {
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
                        text: 'Postingan yang Anda buat tidak akan disimpan',
                        maxlines: 2,
                        style: appstyle(14, null, FontWeight.normal)),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Lanjutkan')),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const RootPage());
                            postFeedBack.postingController.text = '';
                            postFeedBack.image.value = null;
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
              text: 'Buat Postingan',
              style: appstyle(
                  16,
                  themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                  FontWeight.w500)),
          actions: [
            GestureDetector(
                onTap: () async {
                  if (textVisible == true || postFeedBack.image.value == null) {
                    return;
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
                      () {
                        postFeedBack.postFeedBack();
                      },
                    );
                    SmartDialog.dismiss();
                    Get.offAll(() => const RootPage());
                  }
                },
                child: Obx(() => postFeedBack.image.value == null
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeController.isDarkTheme()
                              ? const Color(0xff8a8d92).withOpacity(0.6)
                              : const Color(0xff8a8d92).withOpacity(0.4),
                        ),
                        child: ReusableText(
                            text: 'POSTING',
                            style: appstyle(
                                15,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value).withOpacity(0.6)
                                    : Color(kLight.value).withOpacity(0.5),
                                FontWeight.bold)),
                      )
                    : Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        child: ReusableText(
                            text: 'POSTING',
                            style: appstyle(
                                15, Color(kLight.value), FontWeight.bold)),
                      ))),
          ]),
      body: SingleChildScrollView(
        physics: postFeedBack.postingController.text.isEmpty
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        child: SafeArea(
            child: WillPopScope(
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
                    text: 'Postingan yang Anda buat tidak akan disimpan',
                    maxlines: 2,
                    style: appstyle(14, null, FontWeight.normal)),
                actions: [
                  TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Lanjutkan')),
                  TextButton(
                      onPressed: () {
                        Get.back(result: true);
                        postFeedBack.postingController.text = '';
                        postFeedBack.image.value = null;
                      },
                      child: const Text('Hapus')),
                ],
              ),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 25, backgroundImage: getImage()),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storage.getName(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: themeController.isDarkTheme()
                                            ? Color(kLight.value)
                                            : Color(kDark.value),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                              ),
                              Text(
                                storage.getEmail(),
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: themeController.isDarkTheme()
                                            ? Color(kLight.value)
                                            : Color(kDark.value),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Obx(() {
                  return postFeedBack.image.value == null
                      ? Expanded(
                          child: Container(
                            width: width,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: postFeedBack.postingController,
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
                                  postFeedBack.postingController.text == ''
                                      ? textVisible = true
                                      : textVisible = false;
                                });
                              },
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Apa Yang Anda Pikirkan?',
                                  hintStyle: appstyle(
                                      16,
                                      themeController.isDarkTheme()
                                          ? Color(kLightGrey.value)
                                          : Color(kDarkGrey.value),
                                      FontWeight.w500)),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: postFeedBack.postingController,
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
                                    postFeedBack.postingController.text == ''
                                        ? textVisible = true
                                        : textVisible = false;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Apa Yang Anda Pikirkan?',
                                    hintStyle: appstyle(
                                        16,
                                        themeController.isDarkTheme()
                                            ? Color(kLightGrey.value)
                                            : Color(kDarkGrey.value),
                                        FontWeight.w500)),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  color: Colors.transparent,
                                  child: Image.file(
                                    postFeedBack.image.value!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        postFeedBack.deleteImage();
                                      },
                                      icon: Icon(
                                        Ionicons.trash,
                                        color: Color(kRed.value),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        )),
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
                    postFeedBack.getImage(ImageSource.gallery);
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
                    postFeedBack.getImage(ImageSource.camera);
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
    );
  }

  NetworkImage getImage() {
    if (storage.getLogin() == 'False') {
      return const NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      );
    } else {
      if (storage.getStatus() == '1') {
        return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
      } else if (storage.getStatus() == '2') {
        return NetworkImage(storage.getImgGoogle());
      } else if (storage.getStatus() == '3') {
        return NetworkImage(storage.getImgFb());
      } else {
        return const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        );
      }
    }
  }
}
