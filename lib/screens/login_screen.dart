import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart'; // Đảm bảo import đúng
import 'admin_dashboard_screen.dart'; // Import AdminDashboardScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });

    // Lấy giá trị từ controller và kiểm tra xem có trống không
    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();

    // Log giá trị của userName và password để kiểm tra
    print("Username: $userName, Password: $password");

    // Kiểm tra nếu username hoặc password là rỗng hoặc null
    if (userName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields")),
      );
      setState(() {
        isLoading = false;
      });
      return; // Dừng hàm nếu có trường trống
    }

    try {
      // Kiểm tra đăng nhập
      bool success = await AuthService.login(userName, password);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      }
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA07A), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/fpt_logo.png",
                        width: 150,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text("Không tìm thấy hình ảnh", style: TextStyle(color: Colors.red));
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Welcome Back!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 10),
                          const Text("Sign in to your account", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: userNameController,
                            hintText: "Enter your username",
                            isPassword: false,
                            icon: Icons.account_circle_outlined,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: passwordController,
                            hintText: "Enter your password",
                            isPassword: true,
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  text: "Sign in",
                                  onPressed: _login,
                                  color: Colors.deepOrangeAccent,
                                ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              // TODO: Điều hướng đến màn hình đăng ký
                            },
                            child: const Text(
                              "Don't have an account? Sign up",
                              style: TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
