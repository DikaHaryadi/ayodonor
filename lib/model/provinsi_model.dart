class Province {
  final int idProv;
  final String namaProv;

  Province({required this.idProv, required this.namaProv});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      idProv: json['id_prov'] as int,
      namaProv: json['nama_prov'] as String,
    );
  }
}

class KabKota {
  final int idKota;
  final String namaKota;

  KabKota({required this.idKota, required this.namaKota});

  factory KabKota.fromJson(Map<String, dynamic> json) {
    return KabKota(
      idKota: json['id_kota'],
      namaKota: json['nama'],
    );
  }

  @override
  String toString() {
    return namaKota;
  }
}

class Kecamatan {
  final int idKecamatan;
  final String namaKecamatan;

  Kecamatan({required this.idKecamatan, required this.namaKecamatan});

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
      idKecamatan: json['id_kecamatan'],
      namaKecamatan: json['nama_kecamatan'],
    );
  }

  @override
  String toString() {
    return namaKecamatan;
  }
}

// instansi model
class Instansi {
  int idInstansi;
  String namaInstansi;

  Instansi({required this.idInstansi, required this.namaInstansi});

  factory Instansi.fromJson(Map<String, dynamic> json) {
    return Instansi(
      idInstansi: int.parse(json['id_instansi'].toString()), // Parse as integer
      namaInstansi: json['nama'],
    );
  }

  @override
  String toString() {
    return namaInstansi;
  }
}
