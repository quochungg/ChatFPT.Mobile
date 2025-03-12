import 'package:flutter/material.dart';

// Định nghĩa mô hình Role (với name và fullname có thể null)
class Role {
  String? name;  // Chấp nhận giá trị null
  String? fullname;  // Chấp nhận giá trị null

  Role({this.name, this.fullname});  // Khởi tạo với các giá trị nullable
}

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  // Danh sách vai trò (dữ liệu mẫu ban đầu)
  List<Role> roles = [
    Role(name: 'Admin', fullname: 'Administrator - Full Access'),
    Role(name: 'User', fullname: 'Regular User - Limited Access'),
  ];

  // Thêm vai trò mới
  void _addRole() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditRoleScreen(isAddRole: true),
      ),
    );
    if (result != null) {
      setState(() {
        roles.add(result);
      });
    }
  }

  // Chỉnh sửa vai trò
  void _editRole(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoleScreen(
          isAddRole: false,
          role: roles[index],
        ),
      ),
    );
    if (result != null) {
      setState(() {
        roles[index] = result;
      });
    }
  }

  // Xóa vai trò
  void _deleteRole(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm deletion'),
          content: const Text('Are you sure you want to delete this role?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  roles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
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
        title: const Text("Role Management"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(roles[index].name ?? 'Unknown'),
              subtitle: Text(roles[index].fullname ?? 'No description'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editRole(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteRole(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRole,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );
  }
}

class EditRoleScreen extends StatefulWidget {
  final Role? role;
  final bool isAddRole;

  const EditRoleScreen({this.role, required this.isAddRole, super.key});

  @override
  _EditRoleScreenState createState() => _EditRoleScreenState();
}

class _EditRoleScreenState extends State<EditRoleScreen> {
  late TextEditingController nameController;
  late TextEditingController fullnameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.isAddRole ? '' : widget.role?.name ?? '');
    fullnameController = TextEditingController(text: widget.isAddRole ? '' : widget.role?.fullname ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddRole ? 'Add Role' : 'Edit Role'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Role Name'),
            ),
            TextField(
              controller: fullnameController,
              decoration: const InputDecoration(labelText: 'Role Fullname'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && fullnameController.text.isNotEmpty) {
                  final role = Role(
                    name: nameController.text,
                    fullname: fullnameController.text,
                  );
                  Navigator.pop(context, role);
                } else {
                  // Hiển thị lỗi nếu các trường nhập không có giá trị
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide both name and fullname')),
                  );
                }
              },
              child: Text(widget.isAddRole ? 'Add Role' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent, // Cập nhật thuộc tính màu nền
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
