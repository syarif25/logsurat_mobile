import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Light greyish blue background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF374151)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xFF374151)),
                    onPressed: () => controller.logout(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        controller.authService.currentUser.value?.name ?? 'Logsurat',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.authService.currentUser.value?.jabatan ?? 'Kantor Bendahara',
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFF5C6BC0,
                      ), // Indigo color like the reference
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.file_copy,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Posisi Surat Saat Ini',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoadingStats.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final stats = controller.stats.value?.posisiSurat ?? {};
                
                return Column(
                  children: [
                    _buildStatCard(context, 'Staf', stats['Staf'] ?? 0, const Color(0xFF1E3A8A)),
                    const SizedBox(height: 12),
                    _buildStatCard(context, 'Ka. TU', stats['Ka. TU'] ?? 0, const Color(0xFF4C1D95)),
                    const SizedBox(height: 12),
                    _buildStatCard(context, 'Kabag', stats['Kabag'] ?? 0, const Color(0xFF0F766E)),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      'Waka Bendahara',
                      stats['Waka Bendahara'] ?? 0,
                      const Color(0xFFC2410C),
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      'Bendahara',
                      stats['Bendahara'] ?? 0,
                      const Color(0xFFBE123C),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF064E3B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Get.toNamed('/arsip'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.folder_special, color: Colors.white, size: 28),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Arsip Surat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Lacak dan cari seluruh surat',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Rekap 3 Bulan Terakhir',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoadingStats.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final rekap = controller.stats.value?.rekapBulan ?? [];
                if (rekap.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Tidak ada data rekapitulasi.'),
                    ),
                  );
                }
                
                return Column(
                  children: rekap.map((bulanData) {
                    final details = bulanData.details.map((d) {
                      return {'jenis': d.jenis, 'jumlah': d.jumlah};
                    }).toList();
                    
                    return _buildAccordion(context, bulanData.bulan, details);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int count,
    Color themeColor,
  ) {
    return InkWell(
      onTap: () => _showDetailModal(context, title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$count Berkas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> details,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ), // Menghilangkan garis divider bawaan ExpansionTile
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
              fontSize: 16,
            ),
          ),
          iconColor: const Color(0xFF0F766E),
          collapsedIconColor: const Color(0xFF111827),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            ...details.map((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      detail['jenis'],
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      detail['jumlah'].toString(),
                      style: const TextStyle(
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    details.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int)).toString(),
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context, String title) {
    controller.fetchSuratList(posisi: title); // Fetch data when modal opens
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Detail: $title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: Obx(() {
                    if (controller.isLoadingSurat.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        )
                      );
                    }
                    if (controller.suratList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Tidak ada berkas.'),
                        )
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.suratList.length,
                      itemBuilder: (context, index) {
                        final item = controller.suratList[index];
                        final date = DateTime.tryParse(item.tglMasuk) ?? DateTime.now();
                        final timeAgoStr = timeago.format(date, locale: 'id');
                        
                        return _buildMobileListItem(
                          item.nomorPengajuan, 
                          item.namaLembaga, 
                          item.perihal, 
                          '${date.day}/${date.month}/${date.year}', 
                          timeAgoStr.toUpperCase(), 
                          Colors.blue
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileListItem(String no, String lembaga, String perihal, String tgl, String waktu, MaterialColor badgeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      no,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lembaga.isEmpty ? '-' : lembaga,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: badgeColor.shade200),
                ),
                child: Text(
                  waktu,
                  style: TextStyle(
                    color: badgeColor.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            perihal,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 12, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                tgl,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

