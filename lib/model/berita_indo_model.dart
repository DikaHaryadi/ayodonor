class BeritaIndoModel {
  int? id;
  String? img;
  String? typeBerita;
  String? title;
  String? deskripsi;

  BeritaIndoModel({
    this.id,
    this.img,
    this.typeBerita,
    this.title,
    this.deskripsi,
  });

  BeritaIndoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    typeBerita = json['type_berita'];
    title = json['title'];
    deskripsi = json['deskripsi'];
  }
}
