import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));
    final authService = Get.find<AuthService>();
    if (authService.isAuthenticated.value) {
      Get.offNamed('/dashboard');
    } else {
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 200,
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
