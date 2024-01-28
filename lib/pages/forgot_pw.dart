import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/forgot_pw_controller.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/themes_controller.dart';
import '../utils/Custom/custom_loading.dart';
import '../utils/colors.dart';
import '../utils/custom_btn.dart';

class ForgotPw extends StatefulWidget {
  const ForgotPw({super.key});

  @override
  State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {
  ThemeController themeController = Get.put(ThemeController());
  ForgotPwController forgotPwController = Get.put(ForgotPwController());
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        children: [
          const Text(
            "Reset Password",
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold),
          ),
          Image.asset(
            'images/enscure.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const Text(
              "Masukkan email yang terkait dengan akun Anda dan kami akan memberikan langkah selanjutnya untuk mengatur ulang kata sandi Anda.",
              style: TextStyle(fontSize: 16, fontFamily: 'Barlow')),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: passController,
              decoration: const InputDecoration(
                  labelText: 'Masukan Password Baru',
                  prefixIcon: Icon(Icons.verified_user_outlined),
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: confirmpassController,
              decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.verified_user_outlined),
                  border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onTap: () async {
              if (passController.text.isEmpty ||
                  !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(confirmpassController.text)) {
                forgotPwController.showProgress.value = true;
                Get.snackbar('Warning :',
                    '* Harap masukan password minimal :\n8 karakter, huruf besar, angka dan symbol');
                FocusScope.of(context).requestFocus(FocusNode());
              } else {
                FocusScope.of(context).requestFocus(FocusNode());
                forgotPwController.showProgress.value = true;
                forgotPwController.showProgress.value
                    ? SmartDialog.showLoading(
                        animationType: SmartAnimationType.scale,
                        builder: (_) => const CustomLoading(),
                      )
                    : forgotPwController.showProgress.value = false;
                await forgotPwController.forgotPw(
                    passController.text, confirmpassController.text);
                await Future.delayed(const Duration(seconds: 2));
                SmartDialog.dismiss();
              }
            },
            text: 'Change Password',
          ),
        ],
      ),
    ));
  }
}
