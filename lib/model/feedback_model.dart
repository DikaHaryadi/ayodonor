class FeedBackModel {
  late final int? id;
  String? img;
  String? imgUser;
  String? user;
  String? nik;
  String? golDarah;
  String? deskripsi;
  String? status;
  String? createdAt;

  FeedBackModel(
      {this.id,
      this.img,
      this.imgUser,
      this.user,
      this.golDarah,
      this.deskripsi,
      this.status,
      this.createdAt});

  FeedBackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'] ?? '';
    imgUser = json['img_user'];
    user = json['user'];
    nik = json['nik'];
    golDarah = json['gol_darah'];
    deskripsi = json['deskripsi'];
    status = json['status'];
    createdAt = json['created_at'];
  }
}
