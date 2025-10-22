import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final _storage = kIsWeb ? null : const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  Future<void> login(String token) async {
    await _saveToken(token);
  }

  Future<void> logout() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } else {
      await _storage?.delete(key: _tokenKey);
    }
  }

  Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } else {
      return await _storage?.read(key: _tokenKey);
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    // In a real app, you'd also validate the token's expiration and signature.
    return token != null;
  }

  Future<void> _saveToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } else {
      await _storage?.write(key: _tokenKey, value: token);
    }
  }
}