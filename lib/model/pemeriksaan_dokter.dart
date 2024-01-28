class PemeriksaanDokter {
  late final int? id;
  String? namaInstansi; //
  String? nik; //
  String? userId; //
  String? gula; //
  String? kolesterol; //
  String? beratBadan; //
  String? tinggiBadan; //
  String? asamUrat; //
  String? tekananDarah; //
  String? tglPemeriksaan; //
  String? systolic; //
  String? diastolic; //
  String? pulse; //
  String? heartRate; //
  String? rhesus; //
  String? golDarah; //
  String? status;
  String? namaDokter; //

  PemeriksaanDokter(
      {this.id,
      this.namaInstansi,
      this.nik,
      this.userId,
      this.gula,
      this.kolesterol,
      this.beratBadan,
      this.tinggiBadan,
      this.asamUrat,
      this.tekananDarah,
      this.tglPemeriksaan,
      this.systolic,
      this.diastolic,
      this.pulse,
      this.heartRate,
      this.rhesus,
      this.golDarah,
      this.status,
      this.namaDokter});

  PemeriksaanDokter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaInstansi = json['instansi'];
    userId = json['user_id'];
    nik = json['nik'];
    gula = json['gula'];
    kolesterol = json['kolesterol'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    asamUrat = json['asam_urat'];
    tekananDarah = json['tekanan_darah'];
    tglPemeriksaan = json['tgl'];
    systolic = json['systolic'];
    diastolic = json['diastolic'];
    pulse = json['pulse'];
    heartRate = json['heart_rate'];
    rhesus = json['resus'];
    golDarah = json['gol_darah'];
    status = json['status'];
    namaDokter = json['nama_dokter'];
  }
}
