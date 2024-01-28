class PemeriksaanModel {
  late final int? id;
  String? instansi;
  String? userId;
  String? nik;
  String? gula;
  String? kolesterol;
  String? beratBadan;
  String? tinggiBadan;
  String? asamUrat;
  String? tekananDarah;
  String? tgl;
  String? systolic;
  String? diastolic;
  String? pulse;
  String? heartRate;
  String? resus;
  String? golDarah;
  String? status;
  String? namaDokter;
  String? createdAt;
  String? updatedAt;

  PemeriksaanModel(
      {this.id,
      this.instansi,
      this.userId,
      this.nik,
      this.gula,
      this.kolesterol,
      this.beratBadan,
      this.tinggiBadan,
      this.asamUrat,
      this.tekananDarah,
      this.tgl,
      this.systolic,
      this.diastolic,
      this.pulse,
      this.heartRate,
      this.resus,
      this.golDarah,
      this.status,
      this.namaDokter,
      this.createdAt,
      this.updatedAt});

  PemeriksaanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    instansi = json['instansi'];
    userId = json['user_id'];
    nik = json['nik'];
    gula = json['gula'];
    kolesterol = json['kolesterol'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    asamUrat = json['asam_urat'];
    tekananDarah = json['tekanan_darah'];
    tgl = json['tgl'];
    systolic = json['systolic'];
    diastolic = json['diastolic'];
    pulse = json['pulse'];
    heartRate = json['heart_rate'];
    resus = json['resus'];
    golDarah = json['gol_darah'];
    status = json['status'];
    namaDokter = json['nama_dokter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
