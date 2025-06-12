import 'package:flutter/material.dart';
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'package:proyek_tpm_praktikum/services/barang_services.dart';

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail barang',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(padding: const EdgeInsets.all(20), child: _barangDetail()),
    );
  }

  // Widget untuk menampilkan detail pakaian dari API
  Widget _barangDetail() {
    return FutureBuilder(
      future: BarangService.getBarangById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final barang = snapshot.data!;
          return _barang(barang, context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Widget untuk menampilkan isi detail pakaian
  Widget _barang(Barang barang, context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1, // Gambar 1:1, persegi
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                barang.foto!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            barang.nama ?? "-",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoText("Nama", barang.nama),
          _infoText("Kategori", barang.kategori),
          _infoText("Deskripsi", barang.deskripsi),
          _infoText("Ukuran", barang.ukuran),
          _infoText("Gender ", barang.jenisKelamin),
          _infoText("Merk", barang.merk),
          _infoText("Kondisi", barang.kondisi),
          _infoText("Harga", "Rp${barang.harga ?? 0}"),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 170,
                height: 40,
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blueGrey,
                //     foregroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => BeliPage(id: id)),
                //     );
                //   },
                //   child: const Text("Beli", style: TextStyle(fontSize: 15)),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi berlabel
  Widget _infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // lebar tetap untuk label
            child: Text(
              "$label",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(value ?? '-', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
