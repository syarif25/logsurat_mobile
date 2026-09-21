import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/surat_model.dart';

class ArsipService extends GetxService {
  final _api = ApiClient().dio;

  Future<List<SuratModel>> getArsipSurat({int page = 1, String query = ''}) async {
    try {
      final response = await _api.get(
        ApiEndpoints.arsip,
        queryParameters: {
          'page': page,
          'search': query,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        var dataList = response.data['data'] as List;
        return dataList.map((e) => SuratModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('GET ARSIP ERROR: $e');
      return [];
    }
  }
}
