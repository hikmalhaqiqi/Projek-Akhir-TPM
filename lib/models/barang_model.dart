class Barang {
  int? id;
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
    this.id,
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
    id = json['id'];
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
    final Map<String, dynamic> data = {};
    if (nama != null) data['nama'] = nama;
    if (kategori != null) data['kategori'] = kategori;
    if (deskripsi != null) data['deskripsi'] = deskripsi;
    if (ukuran != null) data['ukuran'] = ukuran;
    if (jenisKelamin != null) data['jenis_kelamin'] = jenisKelamin;
    if (merk != null) data['merk'] = merk;
    if (kondisi != null) data['kondisi'] = kondisi;
    if (harga != null) data['harga'] = harga;
    if (foto != null) data['foto'] = foto;
    return data;
  }
}
