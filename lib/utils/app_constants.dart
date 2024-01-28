class ApiConstants {
  static const String baseUrl =
      'https://8f85-2001-448a-2002-19ca-3dc3-13bb-702e-ec2.ngrok-free.app/api/';
  static const String detailStockDarah = 'detail-stock-darah';
  static const String loginURL = 'auth/login';
  static const String registerURL = 'auth/register';
  static const String loginDokter = 'auth/login/dokter';
  static const String registerDokter = 'auth/dokter';
  static const String loginAftap = 'auth/login/aftap';
  static const String registerAftap = 'auth/aftap';

  static const String getNewsURL = 'berita';
  static const String getnewsRecoURL = 'berita-rekomendasi';
  static const String getMainNewsURL = 'berita-utama';
  static const String getBloodStock = 'stock-darah';
  static const String getDaftarDarah = 'daftar-darah';
  static const String getHumanDonation = 'get-donasi';
  static const String getDonorSchedule = 'get-jadwal-donor';
  static const String getDonorScheduleByDate = 'get-jadwal-donor-tanggal';
  static const String getFeedBack = 'get-feedback';
  static const String getHistoriDonor = 'histori-donor';
  static const String postFeedBack = 'send-feedback';
  static const String pemeriksaan = 'get-pemeriksaan';
  static const String getDonePemeriksaan = 'get-done-pemeriksaan';
  static const String getDaftarDarahDokter = 'get-daftar-darah';
  static const String pemeriksaanDokter = 'get-dokter-pemeriksaan';
  static const String checkEmail = 'get-google-account';
  static const String saveProfileData = 'auth/complete-profile';
  static const String getLoginGoogle = 'get-login-google';
  static const String getPemeriksaan = 'dokter/change-data-pendonor';
  static const String checkEmailFb = 'get-fb-account';
  static const String getLoginFb = 'get-login-fb';
  static const String saveProfileFb = 'auth/complete-fb';
  static const String checkNik = 'check-nik';
  static const String getPendonorData = 'get-data-pendonor';
  static const String changeProfileKhususDokter =
      'profile/change-profile-khusus-dokter';
  static const String forgotPassword = 'profile/forgot-password';
  static const String changeProfile = 'profile/change-profile';
  static const String getProvinsi = 'get-provinsi';
  static const String getKabKota = 'get-kab-kota';
  static const String getKecamatan = 'get-kecamatan';
  static const String getInstansi = 'get-instansi';
  static const String postPengambilanDarah = 'post-pengambilan-darah';
  static const String getPemeriksaanPendonor = 'get-pemeriksaan-pendonor';
}

class ApiUtils {
  static const String baseUrl =
      "https://8f85-2001-448a-2002-19ca-3dc3-13bb-702e-ec2.ngrok-free.app/api/";
  static const String baseImgURL =
      "https://8f85-2001-448a-2002-19ca-3dc3-13bb-702e-ec2.ngrok-free.app/";

  static String getImageUrl(String imageName) {
    return "${baseImgURL}uploads/$imageName";
  }

  static String getDokterImageUrl(String imageName) {
    return "$baseImgURL$imageName";
  }

  static String getAftapImageUrl(String imageName) {
    return "$baseImgURL$imageName";
  }

  static String getDetailImageUrl(String imageName) {
    return "${baseImgURL}uploads/images/$imageName";
  }

  static String getShearPreferenceImg(String imageName) {
    return "$baseImgURL$imageName";
  }

  static String getFeedBackImg(String imageName) {
    return "$baseImgURL$imageName";
  }
}
