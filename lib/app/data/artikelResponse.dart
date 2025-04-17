class ArtikelResponse {
  String? message;
  List<Artikel>? data;

  ArtikelResponse({this.message, this.data});

  ArtikelResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Artikel>[];
      json['data'].forEach((v) {
        data!.add(Artikel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Artikel {
  int? id;
  String? judul;
  String? slug;
  String? konten;
  String? thumbnail;
  int? status;
  String? catatan;
  String? kategori;
  String? createdAt;
  String? penulis;
  String? ringkasan;

  Artikel({
    this.id,
    this.judul,
    this.slug,
    this.konten,
    this.thumbnail,
    this.status,
    this.catatan,
    this.kategori,
    this.createdAt,
    this.penulis,
    this.ringkasan,
  });

  Artikel.fromJson(Map<String, dynamic> json) {
    id = json['id_art_edu'];
    judul = json['judul_art_edu'];
    slug = json['slug'];
    konten = json['konten_art_edu'];
    thumbnail = json['thumbnail'];
    status = json['art_edu_stat'];
    catatan = json['catatan'];
    kategori = json['kategori_art_edu'];
    createdAt = json['created_at'];
    penulis = json['nama_penulis'];
    ringkasan = json['ringkasan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id_art_edu'] = id;
    json['judul_art_edu'] = judul;
    json['slug'] = slug;
    json['konten_art_edu'] = konten;
    json['thumbnail'] = thumbnail;
    json['art_edu_stat'] = status;
    json['catatan'] = catatan;
    json['kategori_art_edu'] = kategori;
    json['created_at'] = createdAt;
    json['nama_penulis'] = penulis;
    json['ringkasan'] = ringkasan;
    return json;
  }
}
