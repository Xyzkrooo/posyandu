class RiwayatPemeriksaanResponse {
  String? message;
  List<Data>? data;

  RiwayatPemeriksaanResponse({this.message, this.data});

  RiwayatPemeriksaanResponse.fromJson(Map<String, dynamic> json) {
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
  int? idPemeriksaan;
  String? namaAnak;
  double? beratBadan;
  double? tinggiBadan;
  double? lingkarLengan;
  double? lingkarKepala;
  int? asiBlnKe;
  int? asiYaTdk;
  String? tanggalPemeriksaan;
  String? nama;

  Data(
      {this.idPemeriksaan,
      this.namaAnak,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarLengan,
      this.lingkarKepala,
      this.asiBlnKe,
      this.asiYaTdk,
      this.tanggalPemeriksaan,
      this.nama});

  Data.fromJson(Map<String, dynamic> json) {
    idPemeriksaan = json['id_pemeriksaan'];
    namaAnak = json['nama_anak'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    lingkarLengan = json['lingkar_lengan'];
    lingkarKepala = json['lingkar_kepala'];
    asiBlnKe = json['asi_bln_ke'];
    asiYaTdk = json['asi_ya_tdk'];
    tanggalPemeriksaan = json['tanggal_pemeriksaan'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_pemeriksaan'] = this.idPemeriksaan;
    data['nama_anak'] = this.namaAnak;
    data['berat_badan'] = this.beratBadan;
    data['tinggi_badan'] = this.tinggiBadan;
    data['lingkar_lengan'] = this.lingkarLengan;
    data['lingkar_kepala'] = this.lingkarKepala;
    data['asi_bln_ke'] = this.asiBlnKe;
    data['asi_ya_tdk'] = this.asiYaTdk;
    data['tanggal_pemeriksaan'] = this.tanggalPemeriksaan;
    data['nama'] = this.nama;
    return data;
  }
}
