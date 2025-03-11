class AuthService {
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Giả lập delay API

    if (email == "admin@example.com" && password == "r") {
      return true;
    } else {
      throw Exception("Invalid email or password");
    }
  }
}
