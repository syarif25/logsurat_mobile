import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/surat_model.dart';
import 'arsip_controller.dart';

class ArsipScreen extends StatelessWidget {
  final bool isTab;
  ArsipScreen({super.key, this.isTab = false});

  final ArsipController controller = Get.put(ArsipController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: !isTab,
        title: Text(
          'Arsip Surat',
          style: TextStyle(
            color: isDark ? const Color(0xFFF9FAFB) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? const Color(0xFFF9FAFB) : Colors.black87),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: controller.onSearchChanged,
              style: TextStyle(color: isDark ? const Color(0xFFF9FAFB) : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari nomor, perihal, pengirim...',
                hintStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey),
                prefixIcon: Icon(Icons.search, color: isDark ? const Color(0xFF94A3B8) : Colors.grey),
                filled: true,
                fillColor: isDark ? const Color(0xFF334155) : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.arsipList.isEmpty) {
          return const Center(
            child: Text('Tidak ada arsip surat ditemukan.'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchArsip,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.arsipList.length + (controller.isFetchingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.arsipList.length) {
                return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
              }

              final surat = controller.arsipList[index];
              return _buildSuratCard(context, surat);
            },
          ),
        );
      }),
    );
  }

  Widget _buildSuratCard(BuildContext context, SuratModel surat) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String displayStatus = surat.status ?? '-';
    if (displayStatus == 'Diteruskan') {
      displayStatus = 'Proses';
    }

    Color statusColor = Colors.orange;
    if (displayStatus == 'Finish') statusColor = Colors.green;
    if (displayStatus == 'Dikembalikan') statusColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTrackingModal(context, surat),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        surat.lembaga ?? '-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? const Color(0xFFF9FAFB) : Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  surat.jenisSurat ?? '-',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0F766E),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  surat.perihal ?? '-',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFCBD5E1) : Colors.black87,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          surat.posisiSekarang ?? '-',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(surat.tglMasuk),
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTrackingModal(BuildContext context, SuratModel surat) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F766E), // Executive teal header
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Histori / Lacak Surat',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFECFEFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFA5F3FC),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(context, 'Nomor Surat', surat.nomorPengajuan ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'Pengirim', surat.lembaga ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'Jenis Surat', surat.jenisSurat ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(context, 'Perihal', surat.perihal ?? '-'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TIMELINE PERJALANAN SURAT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (surat.histori.isEmpty)
                        Text(
                          'Belum ada histori log untuk surat ini.',
                          style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey),
                        )
                      else
                        ...surat.histori.map((log) => _buildTimelineItem(context, log)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? const Color(0xFF94A3B8) : Colors.black87,
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? const Color(0xFF94A3B8) : Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFF9FAFB) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, LogSuratModel log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color badgeColor = const Color(0xFF10B981); // Emerald
    if (log.status == 'Diproses') badgeColor = Colors.orange;
    if (log.status == 'Dikembalikan') badgeColor = Colors.red;
    if (log.status == 'Finish') badgeColor = Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(color: badgeColor.withValues(alpha: 0.5), blurRadius: 4),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 60,
                color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.posisi ?? '-',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? const Color(0xFFF9FAFB) : Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (log.status ?? '-').toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateDetailed(log.tglLog),
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                if (log.catatan != null && log.catatan != '-' && log.catatan!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.comment,
                          size: 14,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            log.catatan!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? const Color(0xFFCBD5E1) : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateDetailed(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy, HH:mm:ss').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
