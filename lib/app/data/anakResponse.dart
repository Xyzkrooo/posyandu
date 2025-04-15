class AnakResponse {
  String? message;
  List<Data>? data;

  AnakResponse({this.message, this.data});

  AnakResponse.fromJson(Map<String, dynamic> json) {
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
  int? idAnak;
  String? namaAnak;
  String? nikAnak;
  String? tanggalLahir;
  String? jenisKelamin;
  int? anakKe;
  String? beratLahir;
  String? beratBadan;
  String? tinggiBadan;
  String? lingkarKepala;
  String? lingkarLengan;
  int? statusAnak;

  Data(
      {this.idAnak,
      this.namaAnak,
      this.nikAnak,
      this.tanggalLahir,
      this.jenisKelamin,
      this.anakKe,
      this.beratLahir,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarKepala,
      this.lingkarLengan,
      this.statusAnak});

  Data.fromJson(Map<String, dynamic> json) {
    idAnak = json['id_anak'];
    namaAnak = json['nama_anak'];
    nikAnak = json['nik_anak'];
    tanggalLahir = json['tanggal_lahir'];
    jenisKelamin = json['jenis_kelamin'];
    anakKe = json['anak_ke'];
    beratLahir = json['berat_lahir'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    lingkarKepala = json['lingkar_kepala'];
    lingkarLengan = json['lingkar_lengan'];
    statusAnak = json['status_anak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_anak'] = this.idAnak;
    data['nama_anak'] = this.namaAnak;
    data['nik_anak'] = this.nikAnak;
    data['tanggal_lahir'] = this.tanggalLahir;
    data['jenis_kelamin'] = this.jenisKelamin;
    data['anak_ke'] = this.anakKe;
    data['berat_lahir'] = this.beratLahir;
    data['berat_badan'] = this.beratBadan;
    data['tinggi_badan'] = this.tinggiBadan;
    data['lingkar_kepala'] = this.lingkarKepala;
    data['lingkar_lengan'] = this.lingkarLengan;
    data['status_anak'] = this.statusAnak;
    return data;
  }
}
