import 'package:flutter/material.dart';
import 'screens/chat_screen.dart'; // Import file ChatScreen.dart

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
      home: const ChatScreen(), 
    );
  }
}
