class DonasiModel {
  int? id;
  String? imgThumbnail;
  String? title;
  String? tanggal;
  String? deskripsi;
  String? namaBank;
  String? nomerBank;
  String? namaPengguna;

  DonasiModel({
    this.id,
    this.imgThumbnail,
    this.title,
    this.tanggal,
    this.deskripsi,
    this.namaBank,
    this.nomerBank,
    this.namaPengguna,
  });

  DonasiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgThumbnail = json['img_thumbnail'];
    title = json['title'];
    tanggal = json['tanggal'];
    deskripsi = json['deskripsi'];
    namaBank = json['nama_bank'];
    nomerBank = json['nomer_bank'];
    namaPengguna = json['nama_pengguna'];
  }
}
