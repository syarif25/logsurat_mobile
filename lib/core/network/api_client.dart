import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired or invalid
            await _storage.delete(key: 'token');
            Get.offAllNamed('/login');
          }
          return handler.next(e);
        },
      ),
    );
  }
}
