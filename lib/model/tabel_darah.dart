class TabelModel {
  late int id;
  String? idInstansi;
  String? instansi;
  int? jumlah;

  TabelModel({
    required this.id,
    this.idInstansi,
    this.instansi,
    this.jumlah,
  });

  TabelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idInstansi = json['id_instansi'];
    instansi = json['instansi'];
    jumlah = json['jumlah_instansi'];
  }
}
