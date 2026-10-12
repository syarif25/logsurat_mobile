import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../arsip/arsip_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../rekap/rekap_screen.dart';
import 'main_nav_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(MainNavController());

    final List<Widget> pages = [
      ArsipScreen(isTab: true),
      DashboardScreen(),
      RekapScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Obx(
        () => IndexedStack(
          index: navCtrl.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, navCtrl),
    );
  }

  Widget _buildBottomBar(BuildContext context, MainNavController navCtrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Menu 1: Arsip
              _buildNavItem(
                index: 0,
                icon: Icons.folder_outlined,
                activeIcon: Icons.folder_rounded,
                label: 'Arsip',
                navCtrl: navCtrl,
              ),

              // Menu 2: Beranda (Tombol Timbul Lingkaran di Tengah)
              _buildCenterNavItem(
                index: 1,
                icon: Icons.home_rounded,
                label: 'Beranda',
                navCtrl: navCtrl,
              ),

              // Menu 3: Rekap
              _buildNavItem(
                index: 2,
                icon: Icons.bar_chart_rounded,
                activeIcon: Icons.insert_chart_rounded,
                label: 'Rekap',
                navCtrl: navCtrl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required MainNavController navCtrl,
  }) {
    return Obx(() {
      final isSelected = navCtrl.currentIndex.value == index;
      const activeColor = Color(0xFF0F766E);
      const inactiveColor = Color(0xFF9CA3AF);

      return InkWell(
        onTap: () => navCtrl.changePage(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCenterNavItem({
    required int index,
    required IconData icon,
    required String label,
    required MainNavController navCtrl,
  }) {
    return Obx(() {
      final isSelected = navCtrl.currentIndex.value == index;

      return GestureDetector(
        onTap: () => navCtrl.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -14),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withValues(alpha: isSelected ? 0.45 : 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 3.5,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -10),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
