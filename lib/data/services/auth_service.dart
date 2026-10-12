import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class AuthService extends GetxService {
  final _storage = const FlutterSecureStorage();
  final _api = ApiClient().dio;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;

  Future<AuthService> init() async {
    String? token = await _storage.read(key: 'token');
    if (token != null) {
      isAuthenticated.value = true;
    }
    return this;
  }

  Future<String?> login(String username, String password) async {
    try {
      isLoading.value = true;
      final response = await _api.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null && response.data['data']['access_token'] != null) {
        String token = response.data['data']['access_token'];
        await _storage.write(key: 'token', value: token);
        
        if (response.data['data']['user'] != null) {
          currentUser.value = UserModel.fromJson(response.data['data']['user']);
        }
        
        isAuthenticated.value = true;
        return null;
      }
      return "Format respons dari server tidak valid.";
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('LOGIN ERROR: $e');
      }
      if (e.response != null) {
        return e.response?.data['message'] ?? "Server error: ${e.response?.statusCode}";
      } else {
        return "Gagal koneksi ke server. (Cek koneksi internet Anda)";
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LOGIN ERROR: $e');
      }
      return "Terjadi kesalahan internal: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.logout);
    } catch (e) {
      // Ignore errors on logout
    }
    await _storage.delete(key: 'token');
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }
}
