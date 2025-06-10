import 'package:flutter/material.dart';
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'package:proyek_tpm_praktikum/services/barang_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Barang>> _barangFuture;

  @override
  void initState() {
    super.initState();
    _barangFuture = BarangService.getBarang();
  }

  void _refresh() {
    setState(() {
      _barangFuture = BarangService.getBarang();
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Halo,'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<List<Barang>>(
        future: _barangFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Terjadi kesalahan saat mengambil data."),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data Barang kosong."));
          }

          final barang = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: barang.length,
            itemBuilder: (context, index) {
              final item = barang[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  // onTap: () {
                  //   Navigator.push(
                  //     //context,
                  //     // MaterialPageRoute(
                  //     //   builder: (context) =>
                  //     //       //DetailSmartphonePage(id: item.id!),
                  //     // ),
                  //   );
                  // },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.foto!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),

                  title: Text(
                    item.nama!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brand: ${item.kategori}"),
                      Text("Price: \$${item.harga?.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.edit),
                      //   //onPressed: () {
                      //   //   Navigator.push(
                      //   //     context,
                      //   //     MaterialPageRoute(
                      //   //       builder: (context) => EditPage(id: item.id!),
                      //   //     ),
                      //   //   ).then((_) => _refresh());
                      //   // },
                      // ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Barang"),
                              content: const Text(
                                "Yakin ingin menghapus smartphone ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            //await SmartphoneService.deleteSmartphone(item.id!);
                            _refresh();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //await Navigator.push(
          //context,
          //MaterialPageRoute(
          //builder: (context) => const CreateSmartphonePage(),
          //),
          //);
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
