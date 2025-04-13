class ArtikelResponse {
  String? message;
  List<Data>? data;

  ArtikelResponse({this.message, this.data});

  ArtikelResponse.fromJson(Map<String, dynamic> json) {
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
  int? idArtEdu;
  String? judulArtEdu;
  String? slug;
  String? kontenArtEdu;
  String? thumbnail;
  int? artEduStat;
  Null? catatan;
  String? kategoriArtEdu;
  String? createdAt;
  String? namaPenulis;

  Data(
      {this.idArtEdu,
      this.judulArtEdu,
      this.slug,
      this.kontenArtEdu,
      this.thumbnail,
      this.artEduStat,
      this.catatan,
      this.kategoriArtEdu,
      this.createdAt,
      this.namaPenulis});

  Data.fromJson(Map<String, dynamic> json) {
    idArtEdu = json['id_art_edu'];
    judulArtEdu = json['judul_art_edu'];
    slug = json['slug'];
    kontenArtEdu = json['konten_art_edu'];
    thumbnail = json['thumbnail'];
    artEduStat = json['art_edu_stat'];
    catatan = json['catatan'];
    kategoriArtEdu = json['kategori_art_edu'];
    createdAt = json['created_at'];
    namaPenulis = json['nama_penulis'];
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
    data['created_at'] = this.createdAt;
    data['nama_penulis'] = this.namaPenulis;
    return data;
  }
}
