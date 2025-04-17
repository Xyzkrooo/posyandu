class TumbuhKembangResponse {
  bool? status;
  List<Data>? data;

  TumbuhKembangResponse({this.status, this.data});

  TumbuhKembangResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? idAnak;
  String? namaAnak;
  List<Riwayat>? riwayat;

  Data({this.idAnak, this.namaAnak, this.riwayat});

  Data.fromJson(Map<String, dynamic> json) {
    idAnak = json['id_anak'];
    namaAnak = json['nama_anak'];
    if (json['riwayat'] != null) {
      riwayat = <Riwayat>[];
      json['riwayat'].forEach((v) {
        riwayat!.add(new Riwayat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_anak'] = this.idAnak;
    data['nama_anak'] = this.namaAnak;
    if (this.riwayat != null) {
      data['riwayat'] = this.riwayat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Riwayat {
  String? tanggal;
  int? beratBadan;
  int? tinggiBadan;
  int? lingkarKepala;
  int? lingkarLengan;

  Riwayat(
      {this.tanggal,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarKepala,
      this.lingkarLengan});

  Riwayat.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    lingkarKepala = json['lingkar_kepala'];
    lingkarLengan = json['lingkar_lengan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tanggal'] = this.tanggal;
    data['berat_badan'] = this.beratBadan;
    data['tinggi_badan'] = this.tinggiBadan;
    data['lingkar_kepala'] = this.lingkarKepala;
    data['lingkar_lengan'] = this.lingkarLengan;
    return data;
  }
}
