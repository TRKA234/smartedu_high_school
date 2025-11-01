import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/pegawai_model.dart';

class PegawaiService {
  // Ambil daftar pegawai
  Future<List<Pegawai>> fetchPegawaiList() async {
    final response = await http.get(ApiConfig.listPegawaiUrl());
    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') {
      final List<dynamic> items =
          (data['data'] ?? data['pegawai'] ?? []) as List<dynamic>;
      return items
          .map((e) => Pegawai.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    throw Exception(data['message'] ?? 'Gagal memuat data pegawai');
  }

  // Tambah pegawai
  Future<void> createPegawai(Pegawai payload) async {
    final response = await http.post(
      ApiConfig.createPegawaiUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': payload.name,
        'position': payload.position,
        'phone': payload.phone,
        'email': payload.email,
        'address': payload.address,
      }),
    );
    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') return;
    throw Exception(data['message'] ?? 'Gagal menambah pegawai');
  }

  // Update pegawai
  Future<void> updatePegawai(Pegawai payload) async {
    final response = await http.post(
      ApiConfig.updatePegawaiUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id': payload.id,
        'name': payload.name,
        'position': payload.position,
        'phone': payload.phone,
        'email': payload.email,
        'address': payload.address,
      }),
    );
    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') return;
    throw Exception(data['message'] ?? 'Gagal memperbarui pegawai');
  }

  // Hapus pegawai
  Future<void> deletePegawai(int? id) async {
    final response = await http.post(
      ApiConfig.deletePegawaiUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id}),
    );
    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Gagal menghapus pegawai');
    }
  }

  // Utility decode response
  Map<String, dynamic> _decodeResponse(http.Response response) {
    final String body = response.body.trim();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${_short(body)}');
    }
    try {
      final String cleaned = body.replaceFirst(RegExp(r"^[\uFEFF\u200B]+"), '');
      final dynamic decoded = jsonDecode(cleaned);
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return {"status": "error", "message": "Format JSON tidak sesuai"};
    } catch (_) {
      if (body.toLowerCase().contains('success')) {
        return {"status": "success", "data": {}};
      }
      throw Exception('Respon server tidak valid: ${_short(body)}');
    }
  }

  String _short(String s) => s.length > 140 ? '${s.substring(0, 140)}…' : s;
}
