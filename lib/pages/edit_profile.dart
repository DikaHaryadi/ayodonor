import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/edit_profile_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/Custom/custom_loading.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/components/storage_util.dart';
import '../utils/custom_btn.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));
    ThemeController themeController = Get.put(ThemeController());
    EditProfileController controller = Get.put(EditProfileController());

    /* Nanti tanya ke mas bram :
    ini kan update udah bisa semua, nah tpi pas path image lama di update jadi image baru,
    nah pas ngerender image di aplikasi, malah ke rendernya image lama, dan akhirnya gak ada imagenya
    */

    StorageUtil storage = StorageUtil();

    controller.usernameController.text = storage.getName();
    controller.phoneController.text = storage.getPhone();
    controller.pekerjaanController.text = storage.getPekerjaan();
    controller.golDarah.value = storage.getGolDarah();
    controller.rhesus.value = storage.getRhesus();
    controller.jlnRumahController.text = storage.getJlnRumah();

    NetworkImage getImage() {
      if (storage.getStatus() == '1') {
        return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
      } else if (storage.getStatus() == '2') {
        return NetworkImage(storage.getImgGoogle());
      } else if (storage.getStatus() == '3') {
        return NetworkImage(storage.getImgFb());
      }

      // Default image if none of the conditions match
      return const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png');
    }

    // controller.jlnRumahController.text = storage
    //     .getJlnRumah(); //ini kenapa jln_rumahnya gamau muncul -_-, padahal udah di simpen di storage0
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () async {
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
                        child: const Text('Lanjutkan')),
                    TextButton(
                        onPressed: () {
                          // Get.back(result: true);
                          Get.offAll(() => const RootPage());
                        },
                        child: const Text('Hapus')),
                  ],
                ),
              );
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: themeController.isDarkTheme()
                  ? Color(kLight.value)
                  : Color(kDark.value),
            ),
          ),
          actions: const [
            IconButton(
                onPressed: null,
                icon: Icon(Ionicons.information_circle_outline))
          ],
          title: Text('Back',
              style: TextStyle(
                  fontFamily: 'Epilogue',
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        )
      ],
      body: WillPopScope(
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
                    child: const Text('Lanjutkan')),
                TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Hapus')),
              ],
            ),
          );
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          children: [
            const Text(
              "Change Profile",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'images/change_profile.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const Text(
                "Fill in the data below completely and we will change your profile.",
                style: TextStyle(fontSize: 16, fontFamily: 'Barlow')),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          width: 1),
                      color: themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : const Color(0x97BCBABA),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ReusableText(
                          text: 'Data Diri Pendonor',
                          style: appstyle(
                              16,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.w500)),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: "Image Content",
                          context: context,
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            Tween<Offset> tween;
                            tween = Tween(
                                begin: const Offset(0, -1), end: Offset.zero);
                            return SlideTransition(
                              position: tween.animate(
                                CurvedAnimation(
                                    parent: animation, curve: Curves.easeInOut),
                              ),
                              child: child,
                            );
                          },
                          pageBuilder: (context, _, __) => Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Scaffold(
                                backgroundColor: const Color(0xFF000000),
                                body: Container(
                                  width: Get.width,
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: getImage(),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        height: 160,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: getImage(), fit: BoxFit.cover),
                          border: Border.all(
                            width: 4,
                            color: themeController.isDarkTheme()
                                ? Color(kAksenDark.value)
                                : Color(kAksenDark.value),
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: TextFormField(
                      controller: controller.usernameController,
                      focusNode: controller.usernameFocusNode,
                      decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person_2_outlined),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: controller.jlnRumahController,
                      focusNode: controller.alamatFocusNode,
                      decoration: const InputDecoration(
                          labelText: 'Alamat Lengkap',
                          prefixIcon: Icon(Icons.other_houses_outlined),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: controller.pekerjaanController,
                      focusNode: controller.pekerjaanFocusNode,
                      decoration: const InputDecoration(
                          labelText: 'Pekerjaan',
                          prefixIcon: Icon(Icons.maps_home_work_outlined),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      controller: controller.phoneController,
                      focusNode: controller.phoneFocusNode,
                      maxLength: 12,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Nomer Telepon',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          width: 1),
                      color: themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : const Color(0x97BCBABA),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ReusableText(
                          text: 'Golongan Darah Pendonor',
                          style: appstyle(
                              16,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.w500)),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Radio<String>(
                            value: 'A',
                            groupValue: controller.golDarah.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.golDarah.value = value!),
                      ),
                      ReusableText(
                          text: 'A',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal)),
                      Expanded(child: Container()),
                      Obx(
                        () => Radio<String>(
                            value: 'B',
                            groupValue: controller.golDarah.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.golDarah.value = value!),
                      ),
                      ReusableText(
                          text: 'B',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal)),
                      Expanded(child: Container()),
                      Obx(
                        () => Radio<String>(
                            value: 'O',
                            groupValue: controller.golDarah.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.golDarah.value = value!),
                      ),
                      ReusableText(
                          text: 'O',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal)),
                      Expanded(child: Container()),
                      Obx(
                        () => Radio<String>(
                            value: 'AB',
                            groupValue: controller.golDarah.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.golDarah.value = value!),
                      ),
                      ReusableText(
                          text: 'AB',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal)),
                      const SizedBox(width: 10)
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Radio<String>(
                            value: 'N/A',
                            groupValue: controller.golDarah.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.golDarah.value = value!),
                      ),
                      ReusableText(
                          text: 'Tidak Tahu',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal)),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          width: 1),
                      color: themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : const Color(0x97BCBABA),
                    ),
                    child: ReusableText(
                        text: 'Rhesus Darah',
                        style: appstyle(
                            16,
                            themeController.isDarkTheme()
                                ? Color(kLight.value)
                                : Color(kDark.value),
                            FontWeight.w500)),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        Obx(
                          () => Radio<String>(
                              value: '+',
                              groupValue: controller.rhesus.value,
                              activeColor: Colors.red,
                              onChanged: (value) =>
                                  controller.rhesus.value = value!),
                        ),
                        ReusableText(
                            text: '+ (plus)',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.normal)),
                        Expanded(child: Container()),
                        Obx(
                          () => Radio<String>(
                              value: '-',
                              groupValue: controller.rhesus.value,
                              activeColor: Colors.red,
                              onChanged: (value) =>
                                  controller.rhesus.value = value!),
                        ),
                        ReusableText(
                            text: '- (minus)',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.normal)),
                        Expanded(child: Container()),
                        Obx(
                          () => Radio<String>(
                              value: 'N/A',
                              groupValue: controller.rhesus.value,
                              activeColor: Colors.red,
                              onChanged: (value) =>
                                  controller.rhesus.value = value!),
                        ),
                        ReusableText(
                            text: 'Tidak Tahu',
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.normal)),
                        const SizedBox(width: 10)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () async {
                if (controller.golDarah.isEmpty ||
                    controller.pekerjaanController.text.isEmpty ||
                    controller.usernameController.text.isEmpty ||
                    controller.phoneController.text.isEmpty ||
                    controller.jlnRumahController.text.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('Warning :', '* Harap mengisi semua data');
                  FocusScope.of(context).requestFocus(FocusNode());
                } else if (controller.image.value == null) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Foto wajib dimasukan');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.showProgress.value = true;
                  controller.showProgress.value
                      ? SmartDialog.showLoading(
                          animationType: SmartAnimationType.scale,
                          builder: (_) => const CustomLoading(),
                        )
                      : controller.showProgress.value = false;
                  debouncer(
                    () async {
                      await controller.editProfile();
                    },
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  SmartDialog.dismiss();
                }
              },
              text: 'Send Instructions',
            ),
          ],
        ),
      ),
    ));
  }
}
