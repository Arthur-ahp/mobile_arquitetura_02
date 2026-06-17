import 'dart:convert';

import 'package:product_app/domain/entities/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController {
  static final SessionController instance = SessionController._();
  static const String _userKey = 'authenticated_user';

  SessionController._();

  AuthUser? _user;

  AuthUser? get user => _user;

  String? get token => _user?.accessToken;

  bool get isLoggedIn => _user != null;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString(_userKey);
    if (storedUser == null || storedUser.isEmpty) return;

    try {
      final json = jsonDecode(storedUser) as Map<String, dynamic>;
      _user = AuthUser.fromJson(json);
    } catch (_) {
      await prefs.remove(_userKey);
      _user = null;
    }
  }

  Future<void> login(AuthUser user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
