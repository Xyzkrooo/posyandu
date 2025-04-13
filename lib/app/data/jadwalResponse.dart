class JadwalResponse {
  String? message;
  List<Data>? data;

  JadwalResponse({this.message, this.data});

  JadwalResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? idJdp;
  String? namaKegiatan;
  String? tanggalKegiatan;
  String? waktuMulai;
  String? waktuSelesai;
  String? deskripsi;

  Data(
      {this.idJdp,
      this.namaKegiatan,
      this.tanggalKegiatan,
      this.waktuMulai,
      this.waktuSelesai,
      this.deskripsi});

  Data.fromJson(Map<String, dynamic> json) {
    idJdp = json['id_jdp'];
    namaKegiatan = json['nama_kegiatan'];
    tanggalKegiatan = json['tanggal_kegiatan'];
    waktuMulai = json['waktu_mulai'];
    waktuSelesai = json['waktu_selesai'];
    deskripsi = json['deskripsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_jdp'] = this.idJdp;
    data['nama_kegiatan'] = this.namaKegiatan;
    data['tanggal_kegiatan'] = this.tanggalKegiatan;
    data['waktu_mulai'] = this.waktuMulai;
    data['waktu_selesai'] = this.waktuSelesai;
    data['deskripsi'] = this.deskripsi;
    return data;
  }
}
