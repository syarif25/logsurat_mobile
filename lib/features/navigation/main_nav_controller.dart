import 'package:get/get.dart';

class MainNavController extends GetxController {
  // Index: 0 = Arsip, 1 = Beranda, 2 = Rekap
  final RxInt currentIndex = 1.obs; // Beranda as default

  void changePage(int index) {
    currentIndex.value = index;
  }
}
