import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';

class RekapScreen extends StatelessWidget {
  RekapScreen({super.key});

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Rekapitulasi Surat',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoadingStats.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = controller.stats.value;
        if (stats == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Belum ada data rekapitulasi.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.fetchStats(),
                  child: const Text('Muat Ulang'),
                ),
              ],
            ),
          );
        }

        final summary = stats.summary;
        final rekapBulanList = stats.rekapBulan;
        final trendLabels = stats.chartTrenBulanan['labels'] as List? ?? [];
        final trendValues = stats.chartTrenBulanan['values'] as List? ?? [];

        return RefreshIndicator(
          onRefresh: controller.fetchStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan Status Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Surat',
                        '${summary['total_surat'] ?? 0}',
                        Icons.mark_email_read_outlined,
                        const Color(0xFF0F766E),
                        const Color(0xFFE6FFFA),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Belum Diproses',
                        '${summary['belum_diproses'] ?? 0}',
                        Icons.hourglass_empty_rounded,
                        const Color(0xFFF59E0B),
                        const Color(0xFFFEF3C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Sedang Diproses',
                        '${summary['sedang_diproses'] ?? 0}',
                        Icons.sync_rounded,
                        const Color(0xFF3B82F6),
                        const Color(0xFFDBEAFE),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Selesai',
                        '${summary['selesai'] ?? 0}',
                        Icons.check_circle_outline_rounded,
                        const Color(0xFF10B981),
                        const Color(0xFFD1FAE5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Tren Bulanan Chart Card
                if (trendLabels.isNotEmpty && trendValues.isNotEmpty) ...[
                  const Text(
                    'Tren Surat 6 Bulan Terakhir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 160,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(trendLabels.length, (i) {
                              final int val = (i < trendValues.length && trendValues[i] is num)
                                  ? (trendValues[i] as num).toInt()
                                  : 0;
                              final int maxVal = trendValues
                                  .map((e) => (e is num) ? e.toInt() : 0)
                                  .fold(1, (max, e) => e > max ? e : max);
                              final double barHeight = maxVal > 0 ? (val / maxVal) * 110 : 10;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '$val',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 28,
                                    height: barHeight < 8 ? 8 : barHeight,
                                    decoration: BoxDecoration(
                                      color: i == trendLabels.length - 1
                                          ? const Color(0xFF0F766E)
                                          : const Color(0xFF14B8A6).withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    trendLabels[i].toString().substring(0, 3),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // Rekapitulasi per Bulan Accordions
                const Text(
                  'Rincian Rekap per Bulan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),

                if (rekapBulanList.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Belum ada rincian rekap bulan.')),
                  )
                else
                  ...rekapBulanList.map((item) {
                    final bulanTitle = item.bulan;
                    final details = item.details;
                    final totalBulan = details.fold<int>(
                      0,
                      (sum, d) => sum + d.jumlah,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: item == rekapBulanList.first,
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            bulanTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$totalBulan Berkas',
                              style: const TextStyle(
                                color: Color(0xFF0F766E),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                children: [
                                  const Divider(color: Color(0xFFF3F4F6), height: 16),
                                  ...details.map((detail) {
                                    final jenis = detail.jenis;
                                    final jumlah = detail.jumlah;
                                    final double ratio = totalBulan > 0 ? (jumlah / totalBulan) : 0;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  jenis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF4B5563),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '$jumlah berkas',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFF111827),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: ratio,
                                              minHeight: 5,
                                              backgroundColor: Colors.grey.shade100,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                ratio > 0.3
                                                    ? const Color(0xFF0F766E)
                                                    : const Color(0xFF14B8A6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
