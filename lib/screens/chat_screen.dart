// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   ChatScreenState createState() => ChatScreenState(); 
// }

// class ChatScreenState extends State<ChatScreen> { 
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, dynamic>> messages = [];

//   void _sendMessage() {
//     String text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         messages.add({"text": text, "isUser": true});
//         messages.add({"text": "Xin chào! Tôi là ChatFPT.", "isUser": false});
//       });
//       _controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange[50],
//       appBar: AppBar(
//         title: const Text("ChatFPT"),
//         backgroundColor: Colors.orange,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 bool isUser = messages[index]["isUser"];
//                 return Align(
//                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.orangeAccent : Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           spreadRadius: 1,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       messages[index]["text"],
//                       style: TextStyle(color: isUser ? Colors.white : Colors.black87),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Giao diện ô nhập tin nhắn
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.orange, width: 1),
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             controller: _controller,
//                             decoration: const InputDecoration(
//                               hintText: "Nhập tin nhắn...",
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.send, color: Colors.orange),
//                           onPressed: _sendMessage,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
