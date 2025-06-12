import 'package:flutter/material.dart';
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'package:proyek_tpm_praktikum/pages/home_page.dart';
import 'package:proyek_tpm_praktikum/services/barang_services.dart';

class EditBarangPage extends StatefulWidget {
  final int id;
  const EditBarangPage({super.key, required this.id});

  @override
  State<EditBarangPage> createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final deskripsi = TextEditingController();
  final merk = TextEditingController();
  final harga = TextEditingController();

  String? selectedKategori;
  String? selectedUkuran;
  String? selectedJenisKelamin;
  String? selectedKondisi;

  bool _isDataLoaded = false;
  bool _isLoading = false; // Loading state untuk tombol

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

  Future<void> _updateBarang(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Barang updatedBarang = Barang(
        //id: widget.id,
        nama: nama.text.trim(),
        kategori: selectedKategori,
        deskripsi: deskripsi.text.trim(),
        ukuran: selectedUkuran,
        jenisKelamin: selectedJenisKelamin,
        merk: merk.text.trim(),
        kondisi: selectedKondisi,
        harga: int.tryParse(harga.text),
      );

      final response = await BarangService.updateBarang(
        updatedBarang,
        widget.id,
      );

      if (response == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil mengubah data barang"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context, true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        throw Exception("Gagal memperbarui barang");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit barang',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: BarangService.getBarangById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              if (!_isDataLoaded) {
                final barang = snapshot.data!;
                nama.text = barang.nama ?? '';
                deskripsi.text = barang.deskripsi ?? '';
                merk.text = barang.merk ?? '';
                harga.text = barang.harga?.toString() ?? '';
                selectedKategori = barang.kategori;
                selectedUkuran = barang.ukuran;
                selectedJenisKelamin = barang.jenisKelamin;
                selectedKondisi = barang.kondisi;
                _isDataLoaded = true;
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(nama, "Nama Barang"),
                    _buildTextField(deskripsi, "Deskripsi"),
                    _buildDropdownField(
                      "Kategori",
                      kategoriOptions,
                      selectedKategori,
                      (val) => setState(() => selectedKategori = val),
                    ),
                    _buildDropdownField(
                      "Ukuran",
                      ukuranOptions,
                      selectedUkuran,
                      (val) => setState(() => selectedUkuran = val),
                    ),
                    _buildDropdownField(
                      "Jenis Kelamin",
                      jenisKelaminOptions,
                      selectedJenisKelamin,
                      (val) => setState(() => selectedJenisKelamin = val),
                    ),
                    _buildTextField(merk, "Merk"),
                    _buildDropdownField(
                      "Kondisi",
                      kondisiOptions,
                      selectedKondisi,
                      (val) => setState(() => selectedKondisi = val),
                    ),
                    _buildTextField(
                      harga,
                      "Harga",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }
            return const Center(child: Text("Data tidak ditemukan"));
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: Colors.blueGrey.withOpacity(0.5),
        ),
        onPressed: _isLoading ? null : () => _updateBarang(context),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? '$label tidak boleh kosong'
            : null,
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: options
            .map(
              (option) =>
                  DropdownMenuItem<String>(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? '$label harus dipilih' : null,
      ),
    );
  }
}
