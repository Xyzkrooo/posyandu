class LayananResponse {
  String? message;
  List<Data>? data;

  LayananResponse({this.message, this.data});

  LayananResponse.fromJson(Map<String, dynamic> json) {
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
  int? idLyn;
  String? namaLyn;
  String? slug;
  String? jenisLyn;
  String? gambarLyn;
  String? keteranganLyn;
  String? manfaatLyn;
  String? laranganLyn;
  int? usiaMinimal;
  int? usiaMaksimal;
  String? keteranganSingkat;

  Data(
      {this.idLyn,
      this.namaLyn,
      this.slug,
      this.jenisLyn,
      this.gambarLyn,
      this.keteranganLyn,
      this.manfaatLyn,
      this.laranganLyn,
      this.usiaMinimal,
      this.usiaMaksimal,
      this.keteranganSingkat});

  Data.fromJson(Map<String, dynamic> json) {
    idLyn = json['id_lyn'];
    namaLyn = json['nama_lyn'];
    slug = json['slug'];
    jenisLyn = json['jenis_lyn'];
    gambarLyn = json['gambar_lyn'];
    keteranganLyn = json['keterangan_lyn'];
    manfaatLyn = json['manfaat_lyn'];
    laranganLyn = json['larangan_lyn'];
    usiaMinimal = json['usia_minimal'];
    usiaMaksimal = json['usia_maksimal'];
    keteranganSingkat = json['keterangan_singkat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_lyn'] = this.idLyn;
    data['nama_lyn'] = this.namaLyn;
    data['slug'] = this.slug;
    data['jenis_lyn'] = this.jenisLyn;
    data['gambar_lyn'] = this.gambarLyn;
    data['keterangan_lyn'] = this.keteranganLyn;
    data['manfaat_lyn'] = this.manfaatLyn;
    data['larangan_lyn'] = this.laranganLyn;
    data['usia_minimal'] = this.usiaMinimal;
    data['usia_maksimal'] = this.usiaMaksimal;
    data['keterangan_singkat'] = this.keteranganSingkat;
    return data;
  }
}
