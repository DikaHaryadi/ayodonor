import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/fb_controller.dart';
import 'package:getdonor/controllers/login_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/check_nik.dart';
import 'package:getdonor/pages/register.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/Custom/custom_loading.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/components/app_bar.dart';
import 'package:getdonor/utils/custom_btn.dart';
import 'package:getdonor/utils/reusable_text.dart';

import '../controllers/google_sigin_controller.dart';
import '../utils/Custom/custom_textfield.dart';
import '../utils/app_style.dart';
import '../utils/components/storage_util.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late int tag;
  List<String> roles = [
    'Pendonor',
    'Dokter',
    'Petugas AFTAP',
  ];

  final LoginController loginController = Get.put(LoginController());
  final GoogleController googleController = Get.put(GoogleController());
  final ThemeController themeController = Get.put(ThemeController());
  final FacebookAuthController fbController = Get.put(FacebookAuthController());

  bool? passwordVisible = true;
  final StorageUtil storage = StorageUtil();

  final int maxBackPressCount = 2;

  final RxInt backPressCount = 0.obs;

  @override
  void initState() {
    passwordVisible = true;
    tag = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (backPressCount.value == maxBackPressCount) {
            return true;
          } else {
            Get.snackbar(
              "Keluar :",
              "Klik 2x untuk keluar aplikasi",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
            backPressCount.value++;

            Future.delayed(const Duration(seconds: 2), () {
              backPressCount.value = 0;
            });

            return false;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              bgColor: Theme.of(context).scaffoldBackgroundColor,
              iconColor: themeController.isDarkTheme()
                  ? Color(kLight.value)
                  : Color(kDarkicon.value),
              fontFamily: 'Epilogue',
              automaticallyImplyLeading: false,
              text: 'Unit Donor Darah Pusat PMI',
            ),
          ),
          body: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const SizedBox(height: 30),
                ReusableText(
                  text: 'Selamat Datang!',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      color: themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kLightGrey.value),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                    tag == 0
                        ? 'Isi detail untuk masuk ke akun anda'
                        : tag == 1
                            ? 'Harap mengisi detail sebagai dokter'
                            : tag == 2
                                ? 'Isi detail untuk masuk sebagai petugas AFTAP'
                                : '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kDarkGrey.value),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Barlow')),
                const SizedBox(height: 50),
                Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
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
                            text: 'Masuk sebagai',
                            style: appstyle(
                                16,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDarkGrey.value),
                                FontWeight.w500)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ChipsChoice<int>.single(
                          value: tag,
                          onChanged: (val) => setState(() {
                            tag = val;
                            loginController.emailController.clear();
                            loginController.passController.clear();
                            print(tag);
                          }),
                          choiceItems: C2Choice.listFrom<int, String>(
                            source: roles,
                            value: (i, v) => i,
                            label: (i, v) => v,
                            tooltip: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          choiceStyle: C2ChipStyle.filled(
                            selectedStyle: const C2ChipStyle(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                tag == 0
                    ? Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: loginController.emailController,
                              focusNode: loginController.emailFocusNode,
                              hintText: 'Email Pendonor',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: loginController.passController,
                              focusNode: loginController.passwordFocusNode,
                              hintText: 'Passsword',
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              obscureText: passwordVisible,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible =
                                        passwordVisible == true ? false : true;
                                  });
                                },
                                child: Icon(
                                  passwordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : const Color(0xFF9B9B9B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                tag == 1
                    ? Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: loginController.emailController,
                              focusNode: loginController.emailFocusNode,
                              hintText: 'Email Dokter',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: loginController.passController,
                              focusNode: loginController.passwordFocusNode,
                              hintText: 'Passsword',
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              obscureText: passwordVisible,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible =
                                        passwordVisible == true ? false : true;
                                  });
                                },
                                child: Icon(
                                  passwordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : const Color(0xFF9B9B9B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                tag == 2
                    ? Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: loginController.emailController,
                              focusNode: loginController.emailFocusNode,
                              hintText: 'Email Petugas AFTAP',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: loginController.passController,
                              focusNode: loginController.passwordFocusNode,
                              hintText: 'Passsword',
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              obscureText: passwordVisible,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible =
                                        passwordVisible == true ? false : true;
                                  });
                                },
                                child: Icon(
                                  passwordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : const Color(0xFF9B9B9B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: tag == 0
                      ? MainAxisAlignment.spaceBetween
                      : tag == 1 || tag == 2
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => const RootPage());
                      },
                      child: ReusableText(
                          text: tag == 0
                              ? 'Masuk sebagai Tamu?'
                              : tag == 1
                                  ? ''
                                  : tag == 2
                                      ? ''
                                      : '',
                          style: appstyle(
                              13,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Colors.blue,
                              FontWeight.w500)),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Get.to(() => Register(tag: tag)),
                        child: ReusableText(
                            maxlines: 2,
                            text: tag == 0
                                ? 'Daftar sebagai pendonor'
                                : tag == 1
                                    ? 'Daftar sebagai dokter'
                                    : tag == 2
                                        ? 'Daftar sebagai petugas AFTAP'
                                        : '',
                            textAlign: TextAlign.end,
                            style: appstyle(
                                13,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Colors.blue,
                                FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomButton(
                  onTap: () async {
                    if (tag == 0) {
                      if (loginController.emailController.text.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(loginController.emailController.text)) {
                        loginController.showProgress.value = true;
                        Get.snackbar('Warning :',
                            '* Email Pendonor harus diisi dengan benar');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (loginController.passController.text.isEmpty ||
                          loginController.passController.text == '') {
                        loginController.showProgress.value = true;
                        Get.snackbar(
                            'Warning :', '* Password tidak boleh kosong');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                        loginController.showProgress.value = true;
                        loginController.showProgress.value
                            ? SmartDialog.showLoading(
                                animationType: SmartAnimationType.scale,
                                builder: (_) => const CustomLoading(),
                              )
                            : loginController.showProgress.value = false;

                        await loginController.login();
                        await Future.delayed(const Duration(seconds: 2));
                        SmartDialog.dismiss();
                      }
                    } else if (tag == 1) {
                      if (loginController.emailController.text.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(loginController.emailController.text)) {
                        loginController.showProgress.value = true;
                        Get.snackbar('Warning :',
                            '* Email Dokter harus diisi dengan benar');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (loginController.passController.text.isEmpty ||
                          loginController.passController.text == '') {
                        loginController.showProgress.value = true;
                        Get.snackbar(
                            'Warning :', '* Password tidak boleh kosong');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                        loginController.showProgress.value = true;
                        loginController.showProgress.value
                            ? SmartDialog.showLoading(
                                animationType: SmartAnimationType.scale,
                                builder: (_) => const CustomLoading(),
                              )
                            : loginController.showProgress.value = false;

                        await loginController.loginDokter();
                        await Future.delayed(const Duration(seconds: 2));
                        SmartDialog.dismiss();
                      }
                    } else if (tag == 2) {
                      if (loginController.emailController.text.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(loginController.emailController.text)) {
                        loginController.showProgress.value = true;
                        Get.snackbar('Warning :',
                            '* Email Petugas AFTAP harus diisi dengan benar');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (loginController.passController.text.isEmpty ||
                          loginController.passController.text == '') {
                        loginController.showProgress.value = true;
                        Get.snackbar(
                            'Warning :', '* Password tidak boleh kosong');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                        loginController.showProgress.value = true;
                        loginController.showProgress.value
                            ? SmartDialog.showLoading(
                                animationType: SmartAnimationType.scale,
                                builder: (_) => const CustomLoading(),
                              )
                            : loginController.showProgress.value = false;

                        await loginController.loginAftap();
                        await Future.delayed(const Duration(seconds: 2));
                        SmartDialog.dismiss();
                      }
                    }
                  },
                  text: 'Masuk',
                ),
                tag == 0
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => const CheckNik());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ReusableText(
                              text: 'Lupa Password?',
                              textAlign: TextAlign.center,
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kAksenDark.value),
                                  FontWeight.w500)),
                        ),
                      )
                    : tag == 1 || tag == 2
                        ? const SizedBox.shrink()
                        : const SizedBox.shrink(),
                const SizedBox(height: 10),
              ]),
          bottomNavigationBar: _loginGoogle(),
        ));
  }

  Widget _loginGoogle() {
    return GestureDetector(
      onTap: () {
        googleController.signInWithGoogle();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFBCCEF8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: Get.width * 0.035,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('images/google.png'),
            ),
            const SizedBox(width: 5),
            ReusableText(
                text: 'Masuk dengan akun google',
                style: appstyle(14, Color(kLight.value), FontWeight.bold))
          ],
        ),
      ),
    );
  }

  // Widget _loginKindBtn(List<String> images, BuildContext context) {
  //   double screenWidth = Get.width;
  //   double responsiveRadius = screenWidth * 0.035;

  //   return Wrap(
  //     direction: Axis.horizontal,
  //     spacing: 10,
  //     children: List.generate(
  //       images.length,
  //       (index) {
  //         return InkWell(
  //           onTap: () {
  //             if (index == 0) {
  //               _googleController.signInWithGoogle();
  //             } else if (index == 1) {
  //               fbController.loginFb();
  //             }
  //           },
  //           child: CircleAvatar(
  //             radius: responsiveRadius,
  //             backgroundColor: Colors.transparent,
  //             backgroundImage: AssetImage('images/${images[index]}'),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
