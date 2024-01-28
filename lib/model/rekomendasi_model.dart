class RekomendasiModel {
  int? id;
  String? img;
  String? title;
  String? subtitle;
  String? tglDibuat;
  String? deskripsi;
  String? namaPembuat;
  String? createdAt;
  String? updatedAt;

  RekomendasiModel(
      {this.id,
      this.img,
      this.title,
      this.subtitle,
      this.tglDibuat,
      this.deskripsi,
      this.namaPembuat,
      this.createdAt,
      this.updatedAt});

  RekomendasiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    title = json['title'];
    subtitle = json['subtitle'];
    tglDibuat = json['tgl_dibuat'];
    deskripsi = json['deskripsi'];
    namaPembuat = json['nama_pembuat'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
