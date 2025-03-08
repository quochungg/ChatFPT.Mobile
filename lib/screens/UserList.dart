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
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int currentPage = 1;
  int totalPages = 2; // 20 users, 10 per page = 2 pages

  // Dữ liệu mẫu cho người dùng
  List<Map<String, String>> users = List.generate(
    20,
    (index) => {'name': 'User ${index + 1}', 'email': 'user${index + 1}@example.com'},
  );

  // Hàm lấy danh sách người dùng cho trang hiện tại
  List<Map<String, String>> getUsersForCurrentPage() {
    int startIndex = (currentPage - 1) * 10;
    int endIndex = startIndex + 10;
    if (endIndex > users.length) {
      endIndex = users.length;
    }
    return users.sublist(startIndex, endIndex);
  }

  // Hàm điều hướng đến màn hình thêm người dùng
  void _navigateToAddUserScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserScreen(isAddUser: true)),
    );

    // Nếu có kết quả (người dùng mới được thêm vào), cập nhật lại danh sách
    if (result != null) {
      setState(() {
        users.add(result); // Thêm người dùng mới vào danh sách
        totalPages = (users.length / 10).ceil(); // Cập nhật tổng số trang
      });
    }
  }

  // Hàm điều hướng đến màn hình chỉnh sửa
  void _navigateToEditScreen(Map<String, String> user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserScreen(isAddUser: false, user: user)),
    );

    // Nếu có kết quả (cập nhật thông tin người dùng), cập nhật lại danh sách
    if (result != null) {
      setState(() {
        users[users.indexOf(user)] = result; // Cập nhật người dùng trong danh sách
      });
    }
  }

  // Hàm hiển thị popup xác nhận khi xóa người dùng
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa người dùng này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  users.removeAt(index); // Xóa người dùng tại index
                  totalPages = (users.length / 10).ceil(); // Cập nhật tổng số trang
                });
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Chức năng quay lại
            Navigator.pop(context);
          },
        ),
        title: Text('Manage'),
        centerTitle: true, // Căn giữa tiêu đề "Manage"
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Giữ chữ lệch trái
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Chia đều giữa 'Users List' và dấu cộng
              children: [
                Text(
                  'Users List',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                // Dấu cộng để thêm người dùng chỉ xuất hiện ở góc phải của Users List
                IconButton(
                  icon: Icon(Icons.add_circle, size: 30), // Dấu cộng để thêm người dùng
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
                              // Chuyển đến màn hình chỉnh sửa
                              _navigateToEditScreen(user);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Hiển thị hộp thoại xác nhận xóa khi nhấn nút delete
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
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                ),
                Text('$currentPage of $totalPages pages'),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: currentPage < totalPages
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình chỉnh sửa và thêm thông tin người dùng
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
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Đảm bảo các tiêu đề nằm bên trái
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
                  backgroundColor: Color.fromARGB(255, 239, 146, 5), // Màu cam
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Tăng kích thước nút
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bo tròn nút
                ),
                onPressed: () {
                  Map<String, String> newUser = {
                    'name': nameController.text,
                    'email': emailController.text,
                  };
                  Navigator.pop(context, newUser); // Trả lại kết quả người dùng mới
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
