import 'package:flutter/material.dart';
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'package:proyek_tpm_praktikum/pages/edit_page.dart';
import 'package:proyek_tpm_praktikum/pages/home_page.dart';
import 'package:proyek_tpm_praktikum/services/barang_services.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(padding: const EdgeInsets.all(20), child: _barangDetail()),
    );
  }

  // Widget untuk menampilkan detail pakaian dari API
  Widget _barangDetail() {
    return FutureBuilder(
      future: BarangService.getBarangById(widget.id),
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

          // Row untuk Tombol Edit dan Hapus
          const SizedBox(height: 16),
          Row(
            children: [
              // Tombol Edit
              SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.43, // 43% dari lebar layar
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBarangPage(id: widget.id),
                      ),
                    );

                    // Refresh data jika edit berhasil
                    if (result == true) {
                      setState(() {
                        // Refresh detail page
                      });
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 4),
                      Text("Edit", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10), // jarak antar tombol
              // Tombol Hapus
              SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.43, // 43% dari lebar layar
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showDeleteConfirmation(context, widget.id),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 4),
                      Text("Hapus", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method untuk konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus barang ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBarang(id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  // Method untuk menghapus barang
  Future<void> _deleteBarang(int id) async {
    try {
      final response = await BarangService.deleteBarang(id);

      if (response == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil menghapus barang"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        throw Exception("Gagal menghapus barang");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
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
