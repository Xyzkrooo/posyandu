class RiwayatImunisasiResponse {
  String? message;
  List<Data>? data;

  RiwayatImunisasiResponse({this.message, this.data});

  RiwayatImunisasiResponse.fromJson(Map<String, dynamic> json) {
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
  int? idIv;
  String? namaAnak;
  String? layanan;
  String? statusImunisasi;
  int? isOutsideSchedule;
  String? keterangan;
  String? tanggalPemberian;
  String? nama;

  Data(
      {
      this.idIv,
      this.namaAnak,
      this.layanan,
      this.statusImunisasi,
      this.isOutsideSchedule,
      this.keterangan,
      this.tanggalPemberian,
      this.nama});

  Data.fromJson(Map<String, dynamic> json) {
    idIv = json['id_iv'];
    namaAnak = json['nama_anak'];
    layanan = json['layanan'];
    statusImunisasi = json['status_imunisasi'];
    isOutsideSchedule = json['is_outside_schedule'];
    keterangan = json['keterangan'];
    tanggalPemberian = json['tanggal_pemberian'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_iv'] = this.idIv;
    data['nama_anak'] = this.namaAnak;
    data['layanan'] = this.layanan;
    data['status_imunisasi'] = this.statusImunisasi;
    data['is_outside_schedule'] = this.isOutsideSchedule;
    data['keterangan'] = this.keterangan;
    data['tanggal_pemberian'] = this.tanggalPemberian;
    data['nama'] = this.nama;
    return data;
  }
}
