import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/arsip/arsip_screen.dart';
import 'features/arsip/tracking_screen.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AuthService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LogSurat Mobile',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
          name: '/dashboard',
          page: () => DashboardScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/arsip',
          page: () => ArsipScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(name: '/tracking', page: () => const TrackingScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
