class BeritaUtamaModel {
  int? id;
  String? img;
  String? typeBerita;
  String? title;
  String? subtitle;
  String? tanggal;
  String? deskripsi;
  String? namaPembuat;

  BeritaUtamaModel({
    this.id,
    this.img,
    this.typeBerita,
    this.title,
    this.subtitle,
    this.tanggal,
    this.deskripsi,
    this.namaPembuat,
  });

  factory BeritaUtamaModel.fromJson(Map<String, dynamic> json) {
    return BeritaUtamaModel(
      id: json['id'],
      img: json['img'] ??
          'https://c4.wallpaperflare.com/wallpaper/281/773/145/anime-anime-girls-kono-subarashii-sekai-ni-shukufuku-wo-megumin-wallpaper-preview.jpg',
      typeBerita: json['type_berita'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      tanggal: json['tanggal'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      namaPembuat: json['nama_pembuat'] ?? '',
    );
  }
}
