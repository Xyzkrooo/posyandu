class ProfileResponse {
  String? message;
  User? user;

  ProfileResponse({this.message, this.user});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? nama;
  String? username;
  String? noTelp;
  String? email;
  String? role;
  Null? foto;
  String? alamat;
  int? rt;
  int? rw;

  User(
      {this.id,
      this.nama,
      this.username,
      this.noTelp,
      this.email,
      this.role,
      this.foto,
      this.alamat,
      this.rt,
      this.rw});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    username = json['username'];
    noTelp = json['no_telp'];
    email = json['email'];
    role = json['role'];
    foto = json['foto'];
    alamat = json['alamat'];
    rt = json['rt'];
    rw = json['rw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['username'] = this.username;
    data['no_telp'] = this.noTelp;
    data['email'] = this.email;
    data['role'] = this.role;
    data['foto'] = this.foto;
    data['alamat'] = this.alamat;
    data['rt'] = this.rt;
    data['rw'] = this.rw;
    return data;
  }
}
