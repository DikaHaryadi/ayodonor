import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../pages/lengkapi_profile.dart';
import '../pages/rootpage.dart';
import '../utils/app_constants.dart';

class FacebookAuthController extends GetxController {
  final prefs = GetStorage();
  Map<String, dynamic>? userData;
  AccessToken? accessToken;
  bool checking = true;

  @override
  void onInit() {
    // checkIfIsLoggedIn();
    super.onInit();
  }

  // Future<void> checkIfIsLoggedIn() async {
  //   try {
  //     final accessToken = await FacebookAuth.instance.accessToken;
  //     checking = true;
  //     update();

  //     if (accessToken != null) {
  //       final userData = await FacebookAuth.instance.getUserData();
  //       this.accessToken = accessToken;
  //       this.userData = userData;
  //       update();
  //     } else {
  //       await loginFb();
  //     }
  //   } catch (e) {
  //     // Handle errors or exceptions here
  //     print('Error: $e');
  //   }
  // }

  Future<void> loginFb() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
        this.userData = userData;

        if (userData.isNotEmpty) {
          await prefs.write('status', '3');
          await prefs.write('user_facebook', userData['name']);
          await prefs.write('img_facebook', userData['picture']['data']['url']);
          await prefs.write('email_facebook', userData['email']);
          await prefs.write('login_facebook', 'True');

          await checkEmailAndNavigate(userData['email']);
        }
      } else {
        Get.snackbar('Facebook Login Failed - Status: ${result.status}',
            'Message: ${result.message}');
      }
    } catch (e) {
      // Handle errors or exceptions here
      Get.snackbar('Error :', '$e');
    }

    checking = false;
    update();
  }

  Future<void> checkEmailAndNavigate(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.checkEmailFb}?email=$email'), // Ganti dengan URL API server Anda
      );

      if (response.statusCode == 200) {
        final responJson = json.decode(response.body);

        if (responJson['account'] == true) {
          // Email sudah ada dalam database, tampilkan pesan
          try {
            final response = await http.get(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.getLoginFb}?email=$email'), // Ganti dengan URL API server Anda
            );

            if (response.statusCode == 200) {
              final jsonData = json.decode(response.body);
              if (jsonData['success'] == true) {
                await prefs.write('status', '3');
                await prefs.write('status', jsonData['data'][0]["status"]);
                await prefs.write('name', jsonData['data'][0]["name"]);
                await prefs.write('login', 'True');
                await prefs.write('email', jsonData['data'][0]["email"]);
                await prefs.write(
                    'pekerjaan', jsonData['data'][0]["pekerjaan"]);
                await prefs.write(
                    'gol_darah', jsonData['data'][0]["gol_darah"] ?? '');
                await prefs.write('phone', jsonData['data'][0]["phone"] ?? '');
                await prefs.write('nik', jsonData['data'][0]["nik"] ?? '');
                await prefs.write('img', jsonData['data'][0]["img"] ?? '');
                Get.off(() => const RootPage());
              } else {
                Get.off(() => LengkapiProfile(
                      statusLogin: '3',
                    ));
              }
            } else {
              // Tanggapan server tidak valid
              Get.snackbar('Error', 'Terjadi kesalahan pada server');
            }
          } catch (error) {
            // Terjadi kesalahan saat menghubungi server
            Get.snackbar('Error', 'Terjadi kesalahan');
          }
          // Get.snackbar('Success', 'Login Berhasil');
          // Get.off(() => HomeScreen());
        } else {
          // Email belum ada dalam database, navigasikan ke halaman LengkapiProfile
          Get.off(() => LengkapiProfile(
                statusLogin: '3',
              ));
        }
      } else {
        // Tanggapan server tidak valid
        Get.snackbar('Error', 'Terjadi kesalahan pada server');
      }
    } catch (error) {
      // Terjadi kesalahan saat menghubungi server
      Get.snackbar('Error', 'Terjadi kesalahan');
    }
  }

  Future<void> logOutFb() async {
    try {
      await FacebookAuth.instance.logOut();
      prefs.remove('user_facebook');
      prefs.remove('img_facebook');
      prefs.remove('email_facebook');
      prefs.write('login_facebook', 'False');
      prefs.remove('name');
      prefs.write('login', 'False');
      prefs.remove('email');
      prefs.remove('pekerjaan');
      prefs.remove('gol_darah');
      prefs.remove('phone');
      prefs.remove('user_google');
      prefs.remove('nik');
      prefs.remove('img');
      prefs.remove('status');
      accessToken = null;
      userData = null;
      update();
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => const Login());
      });
    } catch (e) {
      // Handle errors or exceptions here
      Get.snackbar('Error :', '$e');
    }
  }
}
