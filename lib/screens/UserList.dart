import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int currentPage = 1;
  int totalPages = 5; // Tổng số trang, bạn có thể điều chỉnh dựa vào số lượng người dùng

  List<Map<String, String>> users = List.generate(
    50,
    (index) => {'name': 'User ${index + 1}', 'email': 'user${index + 1}@example.com'},
  );

  List<Map<String, String>> getUsersForCurrentPage() {
    int startIndex = (currentPage - 1) * 10;
    int endIndex = startIndex + 10;
    if (endIndex > users.length) {
      endIndex = users.length;
    }
    return users.sublist(startIndex, endIndex);
  }

  void _navigateToAddUserScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserScreen(isAddUser: true)),
    );

    if (result != null) {
      setState(() {
        users.add(result);
        totalPages = (users.length / 10).ceil();
      });
    }
  }

  void _navigateToEditScreen(Map<String, String> user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserScreen(isAddUser: false, user: user)),
    );

    if (result != null) {
      setState(() {
        users[users.indexOf(user)] = result;
      });
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: Text('Are you sure you want to delete this user?'),
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
                  users.removeAt(index);
                  totalPages = (users.length / 10).ceil();
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
        // Chuyển đến trang tương ứng khi nhấn vào số trang
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Manage'),
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
                  'Users List',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, size: 30),
                  onPressed: _navigateToAddUserScreen,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: getUsersForCurrentPage().length,
                itemBuilder: (context, index) {
                  var user = getUsersForCurrentPage()[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange.shade50,
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(user['name']!),
                      subtitle: Text(user['email']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              _navigateToEditScreen(user);
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
                // Sử dụng SingleChildScrollView và Expanded để tránh tràn
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
                '1-10 of pages (50 items)', // Đây là ví dụ, hãy thay số này với giá trị chính xác
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditUserScreen extends StatefulWidget {
  final Map<String, String>? user;
  final bool isAddUser;

  EditUserScreen({this.user, required this.isAddUser});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.isAddUser ? '' : widget.user!['name']);
    emailController = TextEditingController(text: widget.isAddUser ? '' : widget.user!['email']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddUser ? 'Add user' : 'Edit user'),
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
              'User name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Add username',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Add user email',
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
                  Map<String, String> newUser = {
                    'name': nameController.text,
                    'email': emailController.text,
                  };
                  Navigator.pop(context, newUser);
                },
                child: Text(widget.isAddUser ? 'Add' : 'Edit', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
