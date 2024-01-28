import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../pages/lengkapi_profile.dart';
import '../utils/app_constants.dart';

class GoogleController extends GetxController {
  final nikController = TextEditingController();
  final usernameController = TextEditingController();
  final tempatKelahiranController = TextEditingController();
  final phoneController = TextEditingController();
  final provinsiController = TextEditingController();
  final kabAtaukotaController = TextEditingController();
  final kecamatanController = TextEditingController();
  final jlnRumahController = TextEditingController();
  final kodePosController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final nikFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final tempatKelahiranFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  final kodePosFc = FocusNode();
  final pekerjaanFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();

  Rx<File?> image = Rx<File?>(null);

  RxString gender = RxString('');
  RxString puasa = RxString('');
  RxString dibutuhkan = RxString('');
  RxString rhesus = RxString('');
  RxString golDarah = RxString('');
  RxString tglKelahiran = RxString('');

  RxString provinsi = RxString('');
  RxString kabAtaukota = RxString('');
  RxString kecamatan = RxString('');

  final prefs = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Rx<GoogleSignInAccount?> googleSignInAccount = Rx<GoogleSignInAccount?>(null);

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      googleSignInAccount.value = account;
      if (account != null) {
        await prefs.write('roles', '0');
        await prefs.write('status', '2');
        await prefs.write('user_google', account.displayName);
        await prefs.write('img_google', account.photoUrl);
        await prefs.write('email_google', account.email);
        await prefs.write('login_google', 'True');

        await checkEmailAndNavigate(account.email);
      }
    } catch (error) {
      Get.snackbar('Error :', 'Error signing in with Google: $error');
    }
  }

  Future<void> checkEmailAndNavigate(String email) async {
    print('navigate');
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.checkEmail}?email=$email'), // Ganti dengan URL API server Anda
      );

      if (response.statusCode == 200) {
        final responJson = json.decode(response.body);

        if (responJson['account'] == true) {
          // Email sudah ada dalam database, tampilkan pesan
          try {
            final response = await http.get(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.getLoginGoogle}?email=$email'), // Ganti dengan URL API server Anda
            );

            if (response.statusCode == 200) {
              final jsonData = json.decode(response.body);
              if (jsonData['success'] == true) {
                await prefs.write('roles', '0');
                await prefs.write('login', 'True');
                await prefs.write('status', jsonData['data'][0]["status"]);
                await prefs.write('nik', jsonData['data'][0]["nik"] ?? '');
                await prefs.write('email', jsonData['data'][0]["email"]);
                await prefs.write('name', jsonData['data'][0]["name"]);
                await prefs.write('phone', jsonData['data'][0]["phone"] ?? '');
                await prefs.write(
                    'kelamin', jsonData['data'][0]["kelamin"] ?? '');
                await prefs.write(
                    'tgl_lahir', jsonData['data'][0]["tgl_lahir"] ?? '');
                await prefs.write(
                    'tempat_lahir', jsonData['data'][0]["tempat_lahir"] ?? '');
                await prefs.write(
                    'gol_darah', jsonData['data'][0]["gol_darah"] ?? '');
                await prefs.write(
                    'rhesus', jsonData['data'][0]["rhesus"] ?? '');
                await prefs.write(
                    'provinsi', jsonData['data'][0]["provinsi"] ?? '');
                await prefs.write(
                    'kabAtaukota', jsonData['data'][0]["kabAtaukota"] ?? '');
                await prefs.write(
                    'kecamatan', jsonData['data'][0]["kecamatan"] ?? '');
                await prefs.write(
                    'jln_rumah', jsonData['data'][0]["jln_rumah"] ?? '');
                await prefs.write(
                    'kodepos', jsonData['data'][0]["kodepos"] ?? '');
                await prefs.write(
                    'pekerjaan', jsonData['data'][0]["pekerjaan"]);
                await prefs.write(
                    'donor_puasa', jsonData['data'][0]["donor_puasa"]);
                await prefs.write('donor_saat_dibutuhkan',
                    jsonData['data'][0]["donor_saat_dibutuhkan"]);

                Get.off(() => const RootPage());
              } else {
                Get.off(() => LengkapiProfile(
                      statusLogin: '2',
                    ));
              }
            } else {
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
                statusLogin: '2',
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

  Future<void> completeProfile(
      String status,
      String nik,
      String email,
      String name,
      String phone,
      String kelamin,
      String tglLahir,
      String tempatLahir,
      String golDarah,
      String rhesus,
      String provinsi,
      String kabAtaukota,
      String kecamatan,
      String jlnRumah,
      String kodePos,
      String pekerjaan,
      String donorPuasa,
      String donorSaatDibutuhkan) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.saveProfileData}'), // Ganti dengan URL API server Anda
        body: {
          'status': status,
          'nik': nik,
          'email': email,
          'name': name,
          'phone': phone,
          'kelamin': kelamin,
          'tgl_lahir': tglLahir,
          'tempat_lahir': tempatLahir,
          'gol_darah': golDarah,
          'rhesus': rhesus,
          'provinsi': provinsi,
          'kabAtaukota': kabAtaukota,
          'kecamatan': kecamatan,
          'jln_rumah': jlnRumah,
          'kodepos': kodePos,
          'pekerjaan': pekerjaan,
          'donor_puasa': donorPuasa,
          'donor_saat_dibutuhkan': donorSaatDibutuhkan
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          // Data berhasil disimpan
          try {
            final response = await http.get(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.getLoginGoogle}?email=$email'), // Ganti dengan URL API server Anda
            );

            if (response.statusCode == 200) {
              final jsonData = json.decode(response.body);
              if (jsonData['success'] == true) {
                await prefs.write('roles', '0');
                await prefs.write('login', 'True');
                await prefs.write('status', jsonData['data'][0]["status"]);
                await prefs.write('nik', jsonData['data'][0]["nik"] ?? '');
                await prefs.write('email', jsonData['data'][0]["email"]);
                await prefs.write('name', jsonData['data'][0]["name"]);
                await prefs.write('phone', jsonData['data'][0]["phone"] ?? '');
                await prefs.write(
                    'kelamin', jsonData['data'][0]["kelamin"] ?? '');
                await prefs.write(
                    'tgl_lahir', jsonData['data'][0]["tgl_lahir"] ?? '');
                await prefs.write(
                    'tempat_lahir', jsonData['data'][0]["tempat_lahir"] ?? '');
                await prefs.write(
                    'gol_darah', jsonData['data'][0]["gol_darah"] ?? '');
                await prefs.write(
                    'rhesus', jsonData['data'][0]["rhesus"] ?? '');
                await prefs.write(
                    'provinsi', jsonData['data'][0]["provinsi"] ?? '');
                await prefs.write(
                    'kabAtaukota', jsonData['data'][0]["kabAtaukota"] ?? '');
                await prefs.write(
                    'kecamatan', jsonData['data'][0]["kecamatan"] ?? '');
                await prefs.write(
                    'jln_rumah', jsonData['data'][0]["jln_rumah"] ?? '');
                await prefs.write(
                    'kodepos', jsonData['data'][0]["kodepos"] ?? '');
                await prefs.write(
                    'pekerjaan', jsonData['data'][0]["pekerjaan"]);
                await prefs.write(
                    'donor_puasa', jsonData['data'][0]["donor_puasa"]);
                await prefs.write('donor_saat_dibutuhkan',
                    jsonData['data'][0]["donor_saat_dibutuhkan"]);

                Get.off(() => const RootPage());
              } else {
                Get.off(() => LengkapiProfile(statusLogin: '2'));
              }
            } else {
              // Tanggapan server tidak valid
              Get.snackbar('Error', 'Terjadi kesalahan pada server');
            }
          } catch (error) {
            // Terjadi kesalahan saat menghubungi server
            Get.snackbar('Error', 'Terjadi kesalahan');
          }
          //  'lokal'
          Get.snackbar('Success', 'Data profil berhasil disimpan');
          Get.offAll(() => const RootPage());
          // Selanjutnya, Anda dapat melakukan navigasi ke halaman berikutnya atau tindakan lain yang diperlukan.
        } else {
          // Terjadi kesalahan saat menyimpan data
          Get.snackbar('Error', 'Data profil gagal disimpan');
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

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    prefs.remove('status');
    prefs.remove('name');
    prefs.write('login', 'False');
    prefs.remove('email');
    prefs.remove('pekerjaan');
    prefs.remove('gol_darah');
    prefs.remove('phone');
    prefs.remove('user_google');
    prefs.remove('nik');
    prefs.remove('img');
    prefs.remove('img_google');
    prefs.remove('email_google');
    googleSignInAccount.value = null;
    Get.offAll(() => const Login());
  }
}
