import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_config.dart';

class AuthService {
  UserModel? currentUser;

  Future<void> login({required String email, required String password}) async {
    final response = await http.post(
      ApiConfig.loginUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') {
      currentUser = UserModel.fromJson(data['data']);
      return;
    }
    throw Exception(data['message'] ?? 'Login gagal');
  }

  Future<void> register(UserModel payload) async {
    final response = await http.post(
      ApiConfig.registerUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': payload.name,
        'email': payload.email,
        'password': payload.password,
        'role': payload.role,
      }),
    );

    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') return;
    throw Exception(data['message'] ?? 'Register gagal');
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final String body = response.body.trim();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: $body');
    }
    try {
      final cleaned = body.replaceFirst(RegExp(r"^[\uFEFF\u200B]+"), '');
      final decoded = jsonDecode(cleaned);
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return {"status": "error", "message": "Format respons tidak sesuai"};
    } catch (_) {
      throw Exception('Respon server tidak valid: $body');
    }
  }
}
