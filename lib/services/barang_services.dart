import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek_tpm_praktikum/models/barang_model.dart';

class BarangService {
  static const String baseUrl =
      "https://api-tpm-server-298647753913.us-central1.run.app/Barang";

  static Future<List<Barang>> getBarang() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> barangList = jsonDecode(response.body);
      return barangList.map((json) => Barang.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data Barang');
    }
  }

  static Future<Barang> getBarangById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Barang.fromJson(data["data"]);
    } else {
      throw Exception('Barang tidak ditemukan');
    }
  }

  static Future<bool> createSmartphone(Barang barang) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(barang.toJson()),
    );

    return response.statusCode == 201; // 201 Created
  }

  static Future<bool> updateSmartphone(Barang barang, int id) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(barang.toJson()),
    );

    return response.statusCode == 200; // 200 OK
  }

  static Future<bool> deleteBarang(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    return response.statusCode == 200; // 200 OK
  }
}
