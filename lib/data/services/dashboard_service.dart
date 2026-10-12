import 'package:get/get.dart';
import '../models/dashboard_stats_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class DashboardService extends GetxService {
  final _api = ApiClient().dio;

  Future<DashboardStatsModel?> getDashboardStats() async {
    try {
      final response = await _api.get(ApiEndpoints.dashboard);
      if (response.statusCode == 200) {
        return DashboardStatsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
