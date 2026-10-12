import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/surat_masuk_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class SuratMasukService extends GetxService {
  final _api = ApiClient().dio;

  Future<List<SuratMasukModel>> getSuratMasuk({int page = 1, int perPage = 10, String? posisi}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'per_page': perPage,
      };
      
      if (posisi != null && posisi.isNotEmpty) {
        queryParams['posisi'] = posisi;
      }

      final response = await _api.get(
        ApiEndpoints.suratMasuk,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawList;
        
        if (response.data['data'] is List) {
          rawList = response.data['data'];
        } else if (response.data['data'] is Map && response.data['data']['data'] is List) {
          rawList = response.data['data']['data'];
        }
        
        if (rawList != null) {
          return (rawList as List).map((item) => SuratMasukModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[SuratMasukService] ERROR: $e\n$st');
      }
      return [];
    }
  }
}
