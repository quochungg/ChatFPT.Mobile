import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> login(String userName, String password) async {
    // Kiểm tra xem userName và password có null hay không
    if (userName.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }

    final String apiUrl = 'https://chatfpt-ehd7bmcvacendfh8.eastasia-01.azurewebsites.net/api/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': userName,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['data']['tokenResponse']['accessToken']; // Lấy token từ phản hồi
        print('Token received: $token'); // Log token để kiểm tra
        return true; // Đăng nhập thành công
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
