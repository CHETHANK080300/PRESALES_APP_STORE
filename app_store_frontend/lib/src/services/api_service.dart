import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_store_frontend/src/models/app_model.dart';
import 'package:app_store_frontend/src/services/auth_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(authService);
});

class ApiService {
  final AuthService _authService;
  late final Dio _dio;

  ApiService(this._authService) {
    final options = BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    );
    _dio = Dio(options);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return response.data;
  }

  Future<List<App>> getApps() async {
    final response = await _dio.get('/apps');
    final data = response.data as List;
    return data.map((json) => App.fromJson(json)).toList();
  }

  Future<void> uploadApp({
    required String name,
    required String version,
    required String purpose,
    required String platform,
    required String filePath,
    required Function(int, int) onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'version': version,
      'purpose': purpose,
      'platform': platform,
      'file': await MultipartFile.fromFile(filePath),
    });

    await _dio.post(
      '/apps/upload',
      data: formData,
      onSendProgress: onSendProgress,
    );
  }
}