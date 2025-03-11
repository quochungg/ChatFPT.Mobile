import 'package:flutter/material.dart';
import 'package:my_app/screens/feedback_screen.dart';
import 'package:my_app/screens/UserList.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Màu nền nhẹ nhàng hơn
      appBar: AppBar(
        title: const Text('Admin - Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 239, 129, 55),
      ),
      body: SingleChildScrollView(
        // Đảm bảo không bị overflow bằng cách cho phép cuộn
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi Admin!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome back to your panel.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Sử dụng LayoutBuilder thay vì MediaQuery
              LayoutBuilder(builder: (context, constraints) {
                // Tính toán số lượng card có thể hiển thị trên một hàng
                final double availableWidth = constraints.maxWidth;
                final double cardWidth = availableWidth > 600
                    ? (availableWidth / 3) - 16 // 3 card/hàng nếu màn hình rộng
                    : (availableWidth / 2) - 12; // 2 card/hàng nếu màn hình hẹp

                return Wrap(
                  spacing: 12, // Khoảng cách ngang giảm xuống
                  runSpacing: 16, // Khoảng cách dọc
                  children: [
                    DashboardCard(
                      icon: Icons.person_add,
                      title: 'Manage User',
                      count: '83',
                      color: Colors.blueAccent,
                      width: cardWidth,
                      onTap: () {
                        // Xử lý khi người dùng bấm vào Manage User
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserListScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      icon: Icons.feedback,
                      title: 'Feedback',
                      count: '86',
                      color: Colors.orange,
                      width: cardWidth,
                      onTap: () {
                        // Điều hướng đến trang Feedback khi người dùng bấm vào
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      icon: Icons.tag,
                      title: 'Tag',
                      count: '83',
                      color: Colors.blueAccent,
                      width: cardWidth,
                      onTap: () {
                        // Xử lý khi người dùng bấm vào Tag
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color color;
  final double width;
  final VoidCallback? onTap; // Thêm callback để xử lý sự kiện khi nhấn vào card

  const DashboardCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Bọc Container trong GestureDetector để xử lý sự kiện nhấn
      onTap: onTap,
      child: Container(
        width: width, // Sử dụng chiều rộng được truyền vào
        height: 120, // Chiều cao cố định
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12), // Giảm padding để tránh overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 28, color: color), // Giảm size icon
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey), // Giảm size icon
                ],
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24, // Giảm font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14, // Giảm font size
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}