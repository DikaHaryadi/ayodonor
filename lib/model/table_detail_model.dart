class SummaryTotalBlood {
  String? namaInstansi;
  num? a;
  num? b;
  num? o;
  num? ab;
  String? alamat;
  String? lat;
  String? lng;

  SummaryTotalBlood({
    this.namaInstansi,
    this.a,
    this.b,
    this.o,
    this.ab,
    this.alamat,
    this.lat,
    this.lng,
  });

  SummaryTotalBlood.fromJson(Map<String, dynamic> json) {
    namaInstansi = json['name'];
    a = json['A'];
    b = json['B'];
    o = json['O'];
    ab = json['AB'];
    alamat = json['alamat'];
    lat = json['lat'];
    lng = json['lng'];
  }
}
