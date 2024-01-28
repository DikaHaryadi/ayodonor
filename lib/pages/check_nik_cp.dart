import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/check_nik_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/info_pertolongan_pertama.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/Custom/custom_loading.dart';
import '../utils/custom_btn.dart';

class CheckNikChangeProfile extends StatefulWidget {
  const CheckNikChangeProfile({super.key});

  @override
  State<CheckNikChangeProfile> createState() => _CheckNikChangeProfileState();
}

class _CheckNikChangeProfileState extends State<CheckNikChangeProfile> {
  ThemeController themeController = Get.put(ThemeController());
  CheckNikController checkNikController = Get.put(CheckNikController());
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: themeController.isDarkTheme()
                  ? Color(kLight.value)
                  : Color(kDark.value),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => const InfoPertolonganPertama());
                },
                icon: const Icon(Ionicons.information_circle_outline))
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
      body: ListView(
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
            'images/auth_pic.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const Text(
              "Masukkan email yang terkait dengan akun Anda dan kami akan memberikan langkah selanjutnya untuk mengubah profil Anda.",
              style: TextStyle(fontSize: 16, fontFamily: 'Barlow')),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: textEditingController,
              maxLength: 16,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Nomor NIK',
                  prefixIcon: Icon(Icons.verified_user_outlined),
                  border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onTap: () async {
              if (textEditingController.text.isEmpty ||
                  textEditingController.text.length < 16 ||
                  !RegExp(r'^[0-9]*$').hasMatch(textEditingController.text)) {
                checkNikController.showProgress.value = true;
                Get.snackbar(
                    'Warning :', '* Nomer Induk Kependudukan harus diisi');
                FocusScope.of(context).requestFocus(FocusNode());
              } else {
                FocusScope.of(context).requestFocus(FocusNode());
                checkNikController.showProgress.value = true;
                checkNikController.showProgress.value
                    ? SmartDialog.showLoading(
                        animationType: SmartAnimationType.scale,
                        builder: (_) => const CustomLoading(),
                      )
                    : checkNikController.showProgress.value = false;
                await checkNikController
                    .checkNikChangeProfile(textEditingController.text);
                await Future.delayed(const Duration(seconds: 2));
                SmartDialog.dismiss();
              }
            },
            text: 'Check Nik',
          ),
        ],
      ),
    ));
  }
}
