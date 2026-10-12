import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'core/services/theme_service.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/navigation/main_nav_screen.dart';
import 'features/arsip/arsip_screen.dart';
import 'features/arsip/tracking_screen.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Kunci orientasi ke Portrait agar layout stabil
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. Sesuaikan gaya System UI (Status Bar Transparan & Bersih)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 3. Global Error Handler & Fallback Widget (Mencegah Grey Screen)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('Caught Flutter Error: ${details.exceptionAsString()}');
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Caught Platform Error: $error');
    }
    return true; // Mencegah crash fatal
  };

  // Tampilan cadangan jika terjadi rendering error di release
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              SizedBox(height: 12),
              Text(
                'Terjadi Kendala Tampilan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                'Silakan muat ulang halaman atau buka kembali aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  };

  // 4. Inisialisasi Service dengan Pengaman (Defensive Initialization)
  try {
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => ThemeService().init());
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Gagal inisialisasi Service: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        title: 'LogSurat',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
          name: '/dashboard',
          page: () => const MainNavigationScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/arsip',
          page: () => ArsipScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/tracking',
          page: () => const TrackingScreen(),
          transition: Transition.rightToLeft,
        ),
      ],
    ));
  }
}
