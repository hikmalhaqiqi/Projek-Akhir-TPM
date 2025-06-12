import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek_tpm_praktikum/models/barang_model.dart';
import 'dart:io';

class BarangService {
  static const String baseUrl =
      "https://api-tpm-server-298647753913.us-central1.run.app";

  static Future<List<Barang>> getBarang() async {
    final response = await http.get(Uri.parse('$baseUrl/Barang'));

    if (response.statusCode == 200) {
      final List<dynamic> barangList = jsonDecode(response.body);
      return barangList.map((json) => Barang.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data Barang');
    }
  }

  static Future<Barang> getBarangById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Barang/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Barang.fromJson(data);
    } else {
      throw Exception('Barang tidak ditemukan');
    }
  }

  static Future<bool> createBarang(Barang barang, File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add'));

      // Tambahkan field-field form dari barang
      request.fields['nama'] = barang.nama ?? '';
      request.fields['kategori'] = barang.kategori ?? '';
      request.fields['deskripsi'] = barang.deskripsi ?? '';
      request.fields['ukuran'] = barang.ukuran ?? '';
      request.fields['jenis_kelamin'] = barang.jenisKelamin ?? '';
      request.fields['merk'] = barang.merk ?? '';
      request.fields['kondisi'] = barang.kondisi ?? '';
      request.fields['harga'] = (barang.harga ?? 0).toString();

      // Debug: Print request details
      print('Request URL: ${request.url}');
      print('Request fields: ${request.fields}');
      print('Image file path: ${imageFile.path}');
      print('Image file exists: ${await imageFile.exists()}');

      // Tambahkan file gambar
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto', // pastikan ini sesuai dengan field name yang diterima di backend
          imageFile.path,
        ),
      );

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Debug: Print response details
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return true;
      } else {
        // Berikan informasi error yang lebih detail
        throw Exception(
          'Gagal upload barang - Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error in createBarang: $e');
      rethrow;
    }
  }

  static Future<bool> updateBarang(Barang barang, int id) async {
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
