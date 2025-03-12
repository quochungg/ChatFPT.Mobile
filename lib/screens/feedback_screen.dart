import 'package:flutter/material.dart';

// Màn hình Feedback cho Chatbot
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Dữ liệu mẫu cho các câu hỏi và câu trả lời
  final List<Map<String, dynamic>> feedbackData = [
    {
      'id': '1',
      'userName': 'Nguyen Van A',
      'question': 'What are the benefits of meditation?',
      'answer':
          'Meditation helps reduce stress, improve focus, and promote mindfulness. Regular practice can lead to better sleep quality and emotional regulation. It can also help with anxiety management and overall mental well-being.',
      'feedback': 'Very helpful information, exactly what I was looking for!',
      'time': '24 hr',
      'liked': true,
      'disliked': false
    },
    {
      'id': '2',
      'userName': 'Tran Thi B',
      'question': 'How to improve sleep quality?',
      'answer':
          'Regular exercise, consistent sleep schedule, avoiding caffeine in the evening, keeping your bedroom dark and cool, and limiting screen time before bed can all help improve sleep quality.',
      'feedback': 'Good advice but I need more specific recommendations.',
      'time': '30 hr',
      'liked': false,
      'disliked': true
    },
    {
      'id': '3',
      'userName': 'Le Van C',
      'question': 'Best diet for weight loss?',
      'answer':
          'A balanced diet with calorie deficit, plenty of proteins and vegetables, whole grains, and limited processed foods works best for sustainable weight loss. It\'s also important to stay hydrated and eat mindfully.',
      'feedback':
          'The information is too general. Would like more specific meal plans.',
      'time': '42 hr',
      'liked': false,
      'disliked': true
    },
  ];

  // Phương thức cập nhật câu trả lời
  void _updateAnswer(String id, String newAnswer) {
    setState(() {
      final index = feedbackData.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        feedbackData[index]['answer'] = newAnswer;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Đếm tổng số câu hỏi, câu trả lời và feedback
    final questionCount = feedbackData.length;
    final answerCount =
        feedbackData.length; // Trong chatbot, mỗi câu hỏi đều có câu trả lời
    final feedbackCount = feedbackData
        .where(
            (item) => item['feedback'] != null && item['feedback'].isNotEmpty)
        .length;

    // Đếm số lượng like và dislike
    final likeCount =
        feedbackData.where((item) => item['liked'] == true).length;
    final dislikeCount =
        feedbackData.where((item) => item['disliked'] == true).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Manage',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi Admin!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Welcome back to your panel.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Feedback title
                const Center(
                  child: Text(
                    'Feedback',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                // Chia thành 3 cột
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.question_answer,
                                    color: Colors.blue, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '$questionCount',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Questions',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat_bubble_outline,
                                    color: Colors.green, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '$answerCount',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Answers',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.rate_review_outlined,
                                    color: Colors.orange, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '$feedbackCount',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Feedbacks',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Feedback items với nội dung rút gọn
                ...feedbackData
                    .map((item) => _buildFeedbackItemWithTruncation(
                          item['id'],
                          item['userName'],
                          item['question'],
                          item['answer'],
                          item['feedback'] ?? '',
                          item['time'],
                          item['liked'] ?? false,
                          item['disliked'] ?? false,
                          context,
                        ))
                    .toList(),

                const SizedBox(height: 16),

                // Pagination - Sửa lại để tránh overflow
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_double_arrow_left,
                              size: 16),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left, size: 16),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                        ),
                        _buildPageButton('1', true),
                        _buildPageButton('2', false),
                        _buildPageButton('3', false),
                        _buildPageButton('4', false),
                        _buildPageButton('5', false),
                        _buildPageButton('...', false),
                        _buildPageButton('8', false),
                        IconButton(
                          icon:
                              const Icon(Icons.keyboard_arrow_right, size: 16),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_double_arrow_right,
                              size: 16),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Total items text
                Center(
                  child: Text(
                    '1-8 of pages (84 items)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget hiển thị nội dung rút gọn với dấu "..." và có thể xem đầy đủ khi bấm vào
  Widget _buildFeedbackItemWithTruncation(
      String id,
      String userName,
      String question,
      String answer,
      String feedback,
      String time,
      bool liked,
      bool disliked,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFullFeedbackDetails(
            context, id, userName, question, answer, feedback, time);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row với thời gian và indicator like/dislike
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.question_answer_outlined,
                        color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Q&A Feedback',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Like/Dislike indicator
                    if (liked)
                      const Icon(Icons.thumb_up, color: Colors.blue, size: 16)
                    else if (disliked)
                      const Icon(Icons.thumb_down, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    // Time
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Question section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Q: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Text(
                    _truncateText(question, 50),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Answer section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: Text(
                    _truncateText(answer, 60),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            // Feedback section (only if feedback exists)
            if (feedback.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'F: ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _truncateText(feedback, 60),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),

            // Tap to view more indicator
            Center(
              child: Text(
                'Tap to view details',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị dialog với toàn bộ nội dung
  void _showFullFeedbackDetails(
      BuildContext context,
      String id,
      String userName,
      String question,
      String answer,
      String feedback,
      String time) {
    // Tạo TextEditingController với giá trị ban đầu là câu trả lời hiện tại
    final TextEditingController answerController =
        TextEditingController(text: answer);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Feedback Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Question:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Answer:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Edit answer if necessary',
                    contentPadding: EdgeInsets.all(8),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                if (feedback.isNotEmpty) ...[
                  const Text(
                    'Feedback:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feedback,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hiển thị tên người dùng bên trái nút Close
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'User: $userName',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Nút lưu khi chỉnh sửa câu trả lời
                    TextButton(
                      onPressed: () {
                        // Cập nhật câu trả lời
                        _updateAnswer(id, answerController.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Hàm rút gọn nội dung và thêm dấu "..." nếu vượt quá độ dài
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildPageButton(String text, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
