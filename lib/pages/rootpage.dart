import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/berita_artikel.dart';
import 'package:getdonor/pages/feedback.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/home_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final RxInt currentPage = 0.obs;
  final RxBool showLoading = false.obs;

  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  final ThemeController themeController = Get.find();

  final List<Widget> pages = [
    HomeScreen(),
    const FeedBack(),
    BeritaArtikel(),
  ];

  late Timer _timer;
  int _start = 3;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void onItemTapped(int index) {
    if (currentPage.value != index) {
      _debouncer(
        () {
          showLoading.value = true;
          startTimer();
          setState(() {
            currentPage.value = index;
          });
        },
      );
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_start < 1) {
          timer.cancel();
          _timer.cancel();
          showLoading.value = false;
        } else {
          _start--;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => showLoading.value
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('images/online_doctor.json'),
                      const SizedBox(height: 15),
                      ReusableText(
                        text: 'Please wait ...',
                        style: appstyle(
                          16,
                          Color(kAksenDark.value),
                          FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              : pages[currentPage.value],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage.value,
        onTap: onItemTapped,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: themeController.isDarkTheme()
            ? Color(kLight.value)
            : Color(kDark.value),
        unselectedItemColor: const Color(0xFF526480),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => onItemTapped(0),
              child: const Icon(Ionicons.grid_outline),
            ),
            activeIcon: const Icon(Ionicons.grid),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => onItemTapped(1),
              child: const Icon(Ionicons.person_outline),
            ),
            activeIcon: const Icon(Ionicons.person),
            label: 'FeedBack',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => onItemTapped(2),
              child: const Icon(Ionicons.earth_outline),
            ),
            activeIcon: const Icon(Ionicons.earth),
            label: 'Berita',
          ),
        ],
      ),
    );
  }
}
