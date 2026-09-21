import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/surat_masuk_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class SuratMasukService extends GetxService {
  final _api = ApiClient().dio;

  Future<List<SuratMasukModel>> getSuratMasuk({int page = 1, int perPage = 10}) async {
    try {
      final response = await _api.get(
        ApiEndpoints.suratMasuk,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        // Handle nested 'data' key for Laravel pagination
        final dynamic listData = response.data['data']['data'] ?? response.data['data'];
        if (listData is List) {
          return listData.map((item) => SuratMasukModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
