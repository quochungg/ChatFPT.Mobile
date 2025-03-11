import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionListScreen(),
    );
  }
}

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});
  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  int currentPage = 1;
  int totalPages = 8; // Tổng số trang, bạn có thể điều chỉnh dựa vào số lượng câu hỏi

  List<Map<String, String>> questions = List.generate(
    84,
    (index) => {'title': 'Question ${index + 1}', 'description': 'Lorem ipsum dolor, consectetur.'},
  );

  List<Map<String, String>> getQuestionsForCurrentPage() {
    int startIndex = (currentPage - 1) * 10;
    int endIndex = startIndex + 10;
    if (endIndex > questions.length) {
      endIndex = questions.length;
    }
    return questions.sublist(startIndex, endIndex);
  }

  void _navigateToAddQuestionScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditQuestionScreen(isAddQuestion: true)),
    );

    if (result != null) {
      setState(() {
        questions.add(result);
        totalPages = (questions.length / 10).ceil();
      });
    }
  }

  void _navigateToEditScreen(Map<String, String> question) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditQuestionScreen(isAddQuestion: false, question: question)),
    );

    if (result != null) {
      setState(() {
        questions[questions.indexOf(question)] = result;
      });
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: Text('Are you sure you want to delete this question?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  questions.removeAt(index);
                  totalPages = (questions.length / 10).ceil();
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = int.parse(text);
        });
      },
      child: Container(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Questions'),
        centerTitle: true,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question List',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, size: 30),
                  onPressed: _navigateToAddQuestionScreen,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: getQuestionsForCurrentPage().length,
                itemBuilder: (context, index) {
                  var question = getQuestionsForCurrentPage()[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange.shade50,
                    child: ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text(question['title']!),
                      subtitle: Text(question['description']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              _navigateToEditScreen(question);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_left, size: 16),
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage = 1;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_left, size: 16),
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPageButton('1', currentPage == 1),
                        _buildPageButton('2', currentPage == 2),
                        _buildPageButton('3', currentPage == 3),
                        _buildPageButton('4', currentPage == 4),
                        _buildPageButton('5', currentPage == 5),
                        _buildPageButton('...', false),
                        _buildPageButton('$totalPages', currentPage == totalPages),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_right, size: 16),
                  onPressed: currentPage < totalPages
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_right, size: 16),
                  onPressed: currentPage < totalPages
                      ? () {
                          setState(() {
                            currentPage = totalPages;
                          });
                        }
                      : null,
                ),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                '1-10 of pages (84 items)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditQuestionScreen extends StatefulWidget {
  final Map<String, String>? question;
  final bool isAddQuestion;

  EditQuestionScreen({this.question, required this.isAddQuestion});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.isAddQuestion ? '' : widget.question!['title']);
    descriptionController = TextEditingController(text: widget.isAddQuestion ? '' : widget.question!['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddQuestion ? 'Add Question' : 'Edit Question'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Add question title',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Question Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Add question description',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 239, 146, 5),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Map<String, String> newQuestion = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                  };
                  Navigator.pop(context, newQuestion);
                },
                child: Text(widget.isAddQuestion ? 'Add' : 'Edit', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
