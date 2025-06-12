import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'package:proyek_tpm_praktikum/pages/home_page.dart';
import 'package:proyek_tpm_praktikum/services/barang_services.dart';

class CreateBarangPage extends StatefulWidget {
  const CreateBarangPage({super.key});

  @override
  State<CreateBarangPage> createState() => _CreateBarangPageState();
}

class _CreateBarangPageState extends State<CreateBarangPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk text fields
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final merkController = TextEditingController();
  final hargaController = TextEditingController();

  // Variables untuk dropdown dan image
  String? selectedKategori;
  String? selectedUkuran;
  String? selectedJenisKelamin;
  String? selectedKondisi;
  File? selectedImage;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Dropdown options
  final List<String> kategoriOptions = [
    'atasan',
    'bawahan',
    'sepatu',
    'outerwear',
    'aksesori',
  ];
  final List<String> ukuranOptions = ['S', 'M', 'L', 'XL'];
  final List<String> jenisKelaminOptions = ['pria', 'wanita'];
  final List<String> kondisiOptions = [
    'Excellent Condition',
    'Good Condition',
    'Fair Condition',
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  Future<void> _createBarang() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih foto produk")),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      Barang newBarang = Barang(
        nama: namaController.text.trim(),
        kategori: selectedKategori,
        deskripsi: deskripsiController.text.trim(),
        ukuran: selectedUkuran,
        jenisKelamin: selectedJenisKelamin,
        merk: merkController.text.trim(),
        kondisi: selectedKondisi,
        harga: int.tryParse(hargaController.text),
      );

      // Kirim data barang dan path file gambar ke API
      final response = await BarangService.createBarang(
        newBarang,
        selectedImage!,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil menambah barang baru")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        throw Exception(response);
      }
    } catch (error) {
      // Close loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Barang Baru',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Barang
              const Text(
                'Nama Barang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: namaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'harus diisi!!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Masukkan nama barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Kategori
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedKategori,
                validator: (value) {
                  if (value == null) {
                    return 'harus dipilih!!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Pilih kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: kategoriOptions.map((String kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(kategori.capitalize()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKategori = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: deskripsiController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Foto Produk
              const Text(
                'Foto Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap untuk pilih foto',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Row untuk Ukuran dan Jenis Kelamin
              Row(
                children: [
                  // Ukuran
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.43, // 45% dari lebar layar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ukuran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: selectedUkuran,
                          validator: (value) {
                            if (value == null) return 'harus dipilih!!';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pilih ukuran',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: ukuranOptions.map((String ukuran) {
                            return DropdownMenuItem<String>(
                              value: ukuran,
                              child: Text(ukuran),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUkuran = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // jarak antar kolom
                  // Jenis Kelamin
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jenis Kelamin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: selectedJenisKelamin,
                          validator: (value) {
                            if (value == null) return 'harus dipilih!!';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pilih',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: jenisKelaminOptions.map((String jenisKelamin) {
                            return DropdownMenuItem<String>(
                              value: jenisKelamin,
                              child: Text(jenisKelamin.capitalize()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedJenisKelamin = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Merk
              const Text(
                'Merk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: merkController,
                decoration: InputDecoration(
                  hintText: 'Masukkan merk barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Kondisi
              const Text(
                'Kondisi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedKondisi,
                validator: (value) {
                  if (value == null) {
                    return 'harus diisi!!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Pilih kondisi barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: kondisiOptions.map((String kondisi) {
                  return DropdownMenuItem<String>(
                    value: kondisi,
                    child: Text(kondisi),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKondisi = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Harga
              const Text(
                'Harga',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'harus diisi!!';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Masukkan harga barang',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _createBarang,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Tambah Barang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    merkController.dispose();
    hargaController.dispose();
    super.dispose();
  }
}

// Extension untuk capitalize string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
