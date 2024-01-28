class HistoriModel {
  int? id;
  String? namaInstansi;
  String? nik;
  String? lokasi;
  String? tgldaftar;
  String? tgldonor;
  String? status;

  HistoriModel({
    this.id,
    this.namaInstansi,
    this.nik,
    this.lokasi,
    this.tgldaftar,
    this.tgldonor,
    this.status,
  });

  HistoriModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaInstansi = json['nama_instansi'];
    nik = json['nik'];
    lokasi = json['lokasi'];
    tgldaftar = json['tgl_daftar'];
    tgldonor = json['tgl_donor'];
    status = json['status'];
  }
}
