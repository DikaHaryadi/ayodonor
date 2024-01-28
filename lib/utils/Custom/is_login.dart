import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/login.dart';

import '../app_style.dart';
import '../colors.dart';
import '../reusable_text.dart';

class IsLogin extends StatelessWidget {
  const IsLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    var height = Get.height;
    var width = Get.height;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/pmi.png',
                  height: 30,
                ),
                themeController.isDarkTheme()
                    ? Image.asset(
                        'images/ayodonorshadow.png',
                        height: 30,
                      )
                    : Image.asset(
                        'images/bannerayodonorweb.png',
                        height: 30,
                      ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.2,
                color: Colors.red,
              ),
              Positioned(
                  bottom: 10,
                  top: 10,
                  left: width * 0.278,
                  right: width * 0.278,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: const NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                        fit: BoxFit.cover,
                        width: width * 0.278,
                        height: width * 0.417,
                      ),
                    ),
                  )),
              Positioned(
                  bottom: 10,
                  top: 10,
                  left: 100,
                  right: 100,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                          fit: BoxFit.fill,
                        )),
                    width: width * 0.4,
                    height: height * 0.2,
                  )),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Get.to(() => const Login());
            },
            child: ReusableText(
                text: 'Anda Harus Login Dulu',
                maxlines: 2,
                style: appstyle(
                    24,
                    themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kDark.value),
                    FontWeight.bold)),
          ),
          const Text(
            'Log in to other features',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          const Spacer(),
          // InkWell(
          //   onTap: () {
          //     Get.to(() => const JadwalDonor());
          //   },
          //   child: const Text(
          //     '^cek jadwal donor selanjutnya^',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontFamily: 'Epilogue',
          //         fontSize: 12,
          //         color: Colors.blue,
          //         fontStyle: FontStyle.italic,
          //         fontWeight: FontWeight.normal),
          //   ),
          // ),
          const SizedBox(height: 5),
          _bottomKartu(),
        ],
      ),
    );
  }

  _bottomKartu() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      color: Colors.red,
      child: const Column(
        children: [
          Text(
            'KARTU PENDOOR DARAH',
            style: TextStyle(
                fontSize: 14, fontFamily: 'Epilogue', color: Colors.white),
          ),
          Text(
            'Palang Merah Indonesia',
            style: TextStyle(
                fontFamily: 'Epilogue', fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
