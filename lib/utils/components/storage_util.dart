import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getdonor/pages/login.dart';

class StorageUtil {
  final prefs = GetStorage();

  String getStatus() {
    return prefs.read('status') ?? '';
  }

  String getRoles() {
    return prefs.read('roles') ?? '';
  }

  String getRhesus() {
    return prefs.read('rhesus') ?? '';
  }

  String getKelamin() {
    return prefs.read('kelamin') ?? '';
  }

  String getName() {
    return prefs.read('name') ?? '';
  }

  String getNameDokter() {
    return prefs.read('nama_dokter') ?? '';
  }

  String getNameAFTAP() {
    return prefs.read('nama_aftap') ?? '';
  }

  String getUserGoogle() {
    return prefs.read('user_google') ?? '';
  }

  String getImgGoogle() {
    return prefs.read('img_google') ?? 'https://i.stack.imgur.com/34AD2.jpg';
  }

  String getemailGoogle() {
    return prefs.read('email_google') ?? '';
  }

  String getloginGoogle() {
    return prefs.read('login_google') ?? '';
  }

  String getUserFb() {
    return prefs.read('user_facebook') ?? '';
  }

  String getImgFb() {
    return prefs.read('img_facebook') ??
        'https://i.pinimg.com/564x/b8/08/07/b8080715de29eabbbba78c1b2c9d70be.jpg';
  }

  String getEmailFb() {
    return prefs.read('email_facebook') ?? '';
  }

  String getLoginFb() {
    return prefs.read('login_facebook') ?? '';
  }

  String getEmail() {
    return prefs.read('email') ?? '';
  }

  String getLogin() {
    return prefs.read('login') ?? '';
  }

  String getPekerjaan() {
    return prefs.read('pekerjaan') ?? '';
  }

  String getJlnRumah() {
    return prefs.read('jln_rumah') ?? '';
  }

  String getGolDarah() {
    return prefs.read('gol_darah') ?? '';
  }

  String getPhone() {
    return prefs.read('phone') ?? '';
  }

  String getNik() {
    return prefs.read('nik') ?? '';
  }

  String getImg() {
    return prefs.read('img') ??
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
  }

  String getProvinsi() {
    return prefs.read('provinsi') ?? '';
  }

  String getKabAtauKota() {
    return prefs.read('kabAtaukota') ?? '';
  }

  String getKecamatan() {
    return prefs.read('kecamatan') ?? '';
  }

  String getInstansiBekerja() {
    return prefs.read('instansi_bekerja') ?? '';
  }

  String getForgotEmail() {
    return prefs.read('forgot_email') ?? '';
  }

  void logout() {
    prefs.remove('name');
    prefs.remove('nama_dokter');
    prefs.remove('nama_aftap');
    prefs.remove('id_aftap');
    prefs.write('login', 'False');
    // prefs.write('roles', '');
    prefs.remove('roles');
    prefs.remove('email');
    prefs.remove('kelamin');
    prefs.remove('pekerjaan');
    prefs.remove('gol_darah');
    prefs.remove('rhesus');
    prefs.remove('phone');
    prefs.remove('user_google');
    prefs.remove('nik');
    prefs.remove('img');
    // prefs.write('status', '');
    prefs.remove('status');
    prefs.remove('provinsi');
    prefs.remove('kabAtaukota');
    prefs.remove('kecamatan');
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAll(() => const Login());
    });
  }
}
