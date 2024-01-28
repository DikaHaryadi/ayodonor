class DataPendonorModel {
  int? id;
  String? nik;
  String? rhesus;
  String? name;
  String? tglLahir;
  String? tempatLahir;
  String? phone;
  String? email;
  String? golDarah;
  String? provinsi;
  String? kabAtaukota;
  String? kecamatan;
  String? jlnRumah;
  String? kodepos;
  String? pekerjaan;

  DataPendonorModel(
      {this.id,
      this.nik,
      this.rhesus,
      this.name,
      this.tglLahir,
      this.tempatLahir,
      this.phone,
      this.email,
      this.golDarah,
      this.provinsi,
      this.kabAtaukota,
      this.kecamatan,
      this.jlnRumah,
      this.kodepos,
      this.pekerjaan});

  DataPendonorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    rhesus = json['rhesus'] ?? '';
    name = json['name'] ?? '';
    tglLahir = json['tgl_lahir'] ?? '';
    tempatLahir = json['tempat_lahir'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    golDarah = json['gol_darah'] ?? '';
    provinsi = json['provinsi'] ?? '';
    kabAtaukota = json['kabAtaukota'] ?? '';
    kecamatan = json['kecamatan'] ?? '';
    jlnRumah = json['jln_rumah'] ?? '';
    kodepos = json['kodepos'] ?? '';
    pekerjaan = json['pekerjaan'] ?? '';
  }
}
