import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_app/models/auth_user.dart';

class AuthService {
  final String baseUrl = 'https://dummyjson.com/auth';

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AuthUser.fromJson(data);
    } else {
      throw Exception('Usuario ou senha invalidos');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Token invalido ou expirado');
    }
  }
}
