import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Peringatan', 
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = Get.find<AuthService>();
      final errorMsg = await authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (errorMsg == null) {
        Get.offNamed('/dashboard');
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        Get.snackbar(
          'Login Gagal', 
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      Get.snackbar(
        'Terjadi Kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Ornamen Blob Abstrak Kanan Atas
          Positioned.fill(child: CustomPaint(painter: _BlobPainter())),
          // Form Login
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/logo.png', height: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selamat\nDatang',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 64),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer Bawah (Lavender / Keunguan lembut)
    final paint1 = Paint()
      ..color = const Color(0xFFC8C4E6).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Layer Atas (Muted Teal / Biru Tosca pudar)
    final paint2 = Paint()
      ..color = const Color(0xFF5CA2B8).withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    // Highlight Hijau (kiri/bawah blob)
    final paint3 = Paint()
      ..color = const Color(0xFF6BC8B0).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width, 0);
    path1.lineTo(size.width * 0.2, 0);
    path1.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.3,
    );
    path1.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.35,
      size.width,
      size.height * 0.5,
    );
    path1.close();
    canvas.drawPath(path1, paint1);

    final path3 = Path();
    path3.moveTo(size.width, size.height * 0.3);
    path3.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width * 0.8,
      size.height * 0.55,
    );
    path3.lineTo(size.width, size.height * 0.55);
    path3.close();
    canvas.drawPath(path3, paint3);

    final path2 = Path();
    path2.moveTo(size.width, 0);
    path2.lineTo(size.width * 0.35, 0);
    path2.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.7,
      size.height * 0.25,
    );
    path2.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.3,
      size.width,
      size.height * 0.45,
    );
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
