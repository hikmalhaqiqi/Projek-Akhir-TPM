class Barang {
  String? nama;
  String? kategori;
  String? deskripsi;
  String? foto;
  String? ukuran;
  String? jenisKelamin;
  String? merk;
  String? kondisi;
  int? harga;

  Barang({
    this.nama,
    this.kategori,
    this.deskripsi,
    this.foto,
    this.ukuran,
    this.jenisKelamin,
    this.merk,
    this.kondisi,
    this.harga,
  });

  Barang.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    kategori = json['kategori'];
    deskripsi = json['deskripsi'];
    foto = json['foto'];
    ukuran = json['ukuran'];
    jenisKelamin = json['jenis_kelamin'];
    merk = json['merk'];
    kondisi = json['kondisi'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    data['kategori'] = this.kategori;
    data['deskripsi'] = this.deskripsi;
    data['foto'] = this.foto;
    data['ukuran'] = this.ukuran;
    data['jenis_kelamin'] = this.jenisKelamin;
    data['merk'] = this.merk;
    data['kondisi'] = this.kondisi;
    data['harga'] = this.harga;
    return data;
  }
}
