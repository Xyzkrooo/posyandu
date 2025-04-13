class DashboardResponse {
  List<Notifikasi>? notifikasi;
  CountdownJadwal? countdownJadwal;
  List<Artikel>? artikel;

  DashboardResponse({this.notifikasi, this.countdownJadwal, this.artikel});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifikasi'] != null) {
      notifikasi = <Notifikasi>[];
      json['notifikasi'].forEach((v) {
        notifikasi!.add(new Notifikasi.fromJson(v));
      });
    }
    countdownJadwal = json['countdown_jadwal'] != null
        ? new CountdownJadwal.fromJson(json['countdown_jadwal'])
        : null;
    if (json['artikel'] != null) {
      artikel = <Artikel>[];
      json['artikel'].forEach((v) {
        artikel!.add(new Artikel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifikasi != null) {
      data['notifikasi'] = this.notifikasi!.map((v) => v.toJson()).toList();
    }
    if (this.countdownJadwal != null) {
      data['countdown_jadwal'] = this.countdownJadwal!.toJson();
    }
    if (this.artikel != null) {
      data['artikel'] = this.artikel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifikasi {
  int? idIv;
  String? tanggalKegiatan;
  String? keterangan;
  String? namaVaksin;
  String? namaAnak;
  String? statusImunisasi;

  Notifikasi(
      {this.idIv,
      this.tanggalKegiatan,
      this.keterangan,
      this.namaVaksin,
      this.namaAnak,
      this.statusImunisasi});

  Notifikasi.fromJson(Map<String, dynamic> json) {
    idIv = json['id_iv'];
    tanggalKegiatan = json['tanggal_kegiatan'];
    keterangan = json['keterangan'];
    namaVaksin = json['nama_vaksin'];
    namaAnak = json['nama_anak'];
    statusImunisasi = json['status_imunisasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_iv'] = this.idIv;
    data['tanggal_kegiatan'] = this.tanggalKegiatan;
    data['keterangan'] = this.keterangan;
    data['nama_vaksin'] = this.namaVaksin;
    data['nama_anak'] = this.namaAnak;
    data['status_imunisasi'] = this.statusImunisasi;
    return data;
  }
}

class CountdownJadwal {
  int? idJdp;
  String? namaKegiatan;
  String? tanggalKegiatan;
  String? deskripsi;
  String? waktuMulai;
  String? waktuSelesai;
  Null? createdAt;
  Null? updatedAt;
  Null? deletedAt;

  CountdownJadwal(
      {this.idJdp,
      this.namaKegiatan,
      this.tanggalKegiatan,
      this.deskripsi,
      this.waktuMulai,
      this.waktuSelesai,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CountdownJadwal.fromJson(Map<String, dynamic> json) {
    idJdp = json['id_jdp'];
    namaKegiatan = json['nama_kegiatan'];
    tanggalKegiatan = json['tanggal_kegiatan'];
    deskripsi = json['deskripsi'];
    waktuMulai = json['waktu_mulai'];
    waktuSelesai = json['waktu_selesai'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_jdp'] = this.idJdp;
    data['nama_kegiatan'] = this.namaKegiatan;
    data['tanggal_kegiatan'] = this.tanggalKegiatan;
    data['deskripsi'] = this.deskripsi;
    data['waktu_mulai'] = this.waktuMulai;
    data['waktu_selesai'] = this.waktuSelesai;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Artikel {
  int? idArtEdu;
  String? judulArtEdu;
  String? slug;
  String? kontenArtEdu;
  String? thumbnail;
  int? artEduStat;
  Null? catatan;
  String? kategoriArtEdu;
  int? idPetugas;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Artikel(
      {this.idArtEdu,
      this.judulArtEdu,
      this.slug,
      this.kontenArtEdu,
      this.thumbnail,
      this.artEduStat,
      this.catatan,
      this.kategoriArtEdu,
      this.idPetugas,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Artikel.fromJson(Map<String, dynamic> json) {
    idArtEdu = json['id_art_edu'];
    judulArtEdu = json['judul_art_edu'];
    slug = json['slug'];
    kontenArtEdu = json['konten_art_edu'];
    thumbnail = json['thumbnail'];
    artEduStat = json['art_edu_stat'];
    catatan = json['catatan'];
    kategoriArtEdu = json['kategori_art_edu'];
    idPetugas = json['id_petugas'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_art_edu'] = this.idArtEdu;
    data['judul_art_edu'] = this.judulArtEdu;
    data['slug'] = this.slug;
    data['konten_art_edu'] = this.kontenArtEdu;
    data['thumbnail'] = this.thumbnail;
    data['art_edu_stat'] = this.artEduStat;
    data['catatan'] = this.catatan;
    data['kategori_art_edu'] = this.kategoriArtEdu;
    data['id_petugas'] = this.idPetugas;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
