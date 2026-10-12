import 'package:get/get.dart';
import '../../data/services/dashboard_service.dart';
import '../../data/services/surat_masuk_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/surat_masuk_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardController extends GetxController {
  final DashboardService _dashboardService = Get.put(DashboardService());
  final SuratMasukService _suratMasukService = Get.put(SuratMasukService());
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoadingStats = false.obs;
  final RxBool isLoadingSurat = false.obs;
  
  final Rx<DashboardStatsModel?> stats = Rx<DashboardStatsModel?>(null);
  final RxList<SuratMasukModel> suratList = <SuratMasukModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    timeago.setLocaleMessages('id', timeago.IdMessages());
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoadingStats.value = true;
    final data = await _dashboardService.getDashboardStats();
    stats.value = data;
    isLoadingStats.value = false;
  }

  Future<void> fetchSuratList({String? posisi}) async {
    isLoadingSurat.value = true;
    final data = await _suratMasukService.getSuratMasuk(page: 1, perPage: 10, posisi: posisi);
    suratList.assignAll(data);
    isLoadingSurat.value = false;
  }

  void logout() {
    authService.logout();
  }
}
