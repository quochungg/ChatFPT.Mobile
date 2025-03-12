import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, String>> categories = []; // Danh sách các category

  // Hàm thêm mới category
  void _addCategory(String name) {
    setState(() {
      categories.add({'name': name});
    });
  }

  // Hàm cập nhật category
  void _updateCategory(int index, String newName) {
    setState(() {
      categories[index]['name'] = newName;
    });
  }

  // Hàm xóa category
  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  // Dialog thêm mới category
  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _addCategory(categoryController.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Dialog cập nhật category
  void _showUpdateCategoryDialog(int index) {
    final TextEditingController categoryController =
        TextEditingController(text: categories[index]['name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _updateCategory(index, categoryController.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
        title: const Text('Categories'),
        backgroundColor: Colors.orange, // Có thể thay đổi màu sắc nếu cần
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog, // Thêm category mới
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categories.isEmpty
            ? const Center(child: Text('No categories available'))
            : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(categories[index]['name']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              _showUpdateCategoryDialog(index); // Sửa category
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteCategory(index); // Xóa category
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
