import 'package:flutter/material.dart';
// import 'screens/chat_screen.dart';
import 'screens/UserList.dart';  // Đảm bảo rằng UserList.dart đã được tạo trong thư mục screens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange, 
      ),
      home:UserListScreen(), // Thay ChatScreen() bằng UserListScreen()
    );
  }
}
