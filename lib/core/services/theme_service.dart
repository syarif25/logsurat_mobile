import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  final _storage = const FlutterSecureStorage();
  final _key = 'isDarkMode';
  final RxBool isDarkMode = false.obs;

  Future<ThemeService> init() async {
    try {
      final val = await _storage.read(key: _key);
      if (val != null) {
        isDarkMode.value = val == 'true';
      }
    } catch (_) {
      isDarkMode.value = false;
    }
    return this;
  }

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    try {
      await _storage.write(key: _key, value: isDarkMode.value.toString());
    } catch (_) {}
  }
}
