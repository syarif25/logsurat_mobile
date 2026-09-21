class ApiEndpoints {
  // TODO: Update base URL for production or different environment
  // For Android emulator testing local Laravel: 'http://10.0.2.2:8000/api'
  // For iOS simulator testing local Laravel: 'http://127.0.0.1:8000/api'
  // For physical device: 'http://<your_ip>:8000/api'
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String refresh = '$baseUrl/auth/refresh';

  // Dashboard
  static const String dashboard = '$baseUrl/dashboard';

  // Surat
  static const String suratMasuk = '$baseUrl/surat-masuk';
  static const String arsip = '$baseUrl/arsip';
}
