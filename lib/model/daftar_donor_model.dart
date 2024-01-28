class DaftarDonorModel {
  int? id;
  String? namaInstansi;
  // String? idProv;
  String? nik;
  String? lokasi;
  String? tglDaftar;
  String? tglDonor;
  String? status;

  DaftarDonorModel(
      {this.id,
      this.namaInstansi,
      // this.idProv,
      this.nik,
      this.lokasi,
      this.tglDaftar,
      this.tglDonor,
      this.status});

  DaftarDonorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaInstansi = json['nama_instansi'];
    // idProv = json['id_prov'];
    nik = json['nik'];
    lokasi = json['lokasi'];
    tglDaftar = json['tgl_daftar'];
    tglDonor = json['tgl_donor'];
    status = json['status'];
  }
}
