import 'package:flutter/material.dart';

class Tag {
  final String id;
  final String name;
  final String description;

  Tag({required this.id, required this.name, required this.description});
}

class TagListPage extends StatefulWidget {
  const TagListPage({Key? key}) : super(key: key);

  @override
  _TagListPageState createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  List<Tag> tags = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  int totalItems = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    // Load mock data instead of API call
    loadMockData();
  }

  void loadMockData() {
    // Mock data for testing
    final mockTags = [
      Tag(id: '1', name: 'Greeting', description: 'Tags for greeting messages'),
      Tag(id: '2', name: 'FAQ', description: 'Frequently asked questions'),
      Tag(id: '3', name: 'Support', description: 'Customer support queries'),
      Tag(id: '4', name: 'Product', description: 'Product related questions'),
      Tag(id: '5', name: 'Pricing', description: 'Questions about pricing'),
      Tag(id: '6', name: 'Feedback', description: 'User feedback categories'),
      Tag(id: '7', name: 'Error', description: 'Error handling responses'),
      Tag(id: '8', name: 'Welcome', description: 'Welcome messages for new users'),
      Tag(id: '9', name: 'Tutorial', description: 'Tutorial and guidance tags'),
      Tag(id: '10', name: 'Feature', description: 'Feature description tags'),
    ];
    
    setState(() {
      tags = mockTags;
      totalItems = mockTags.length;
      totalPages = (totalItems / itemsPerPage).ceil();
      isLoading = false;
    });
  }

  void deleteTag(String id) {
    setState(() {
      tags.removeWhere((tag) => tag.id == id);
      totalItems = tags.length;
      totalPages = (totalItems / itemsPerPage).ceil();
      
      // If we're on a page that no longer exists, go to the last page
      if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tag deleted successfully')),
    );
  }

  void _showAddTagDialog() {
    final TextEditingController nameController = TextEditingController();
    String? selectedCategoryId;
    
    // Get unique categories from existing tags
    final categories = tags
        .map((tag) => {'id': tag.id, 'name': tag.name})
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Tag'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tag Name',
                        hintText: 'Enter tag name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Category:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        hint: const Text('Select a category'),
                        value: selectedCategoryId,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['id'] as String,
                            child: Text(category['name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedCategoryId = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && selectedCategoryId != null) {
                      // Create the API request body according to the Swagger schema
                      final requestBody = {
                        'name': nameController.text,
                        'categoryId': selectedCategoryId,
                      };
                      
                      // Mock API response - create a new Tag
                      final selectedCategory = categories.firstWhere(
                        (c) => c['id'] == selectedCategoryId
                      );
                      
                      final newTag = Tag(
                        id: (totalItems + 1).toString(),
                        name: nameController.text,
                        description: 'Category: ${selectedCategory['name']}',
                      );
                      
                      // Add the new tag to the list
                      setState(() {
                        tags.add(newTag);
                        totalItems = tags.length;
                        totalPages = (totalItems / itemsPerPage).ceil();
                        // Navigate to the last page to show the new tag
                        currentPage = totalPages;
                      });
                      
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tag "${nameController.text}" created successfully')),
                      );
                    } else {
                      // Show error if fields are not filled
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  List<Tag> getPaginatedTags() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage > tags.length ? tags.length : startIndex + itemsPerPage;
    
    if (startIndex >= tags.length) {
      return [];
    }
    
    return tags.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final paginatedTags = getPaginatedTags();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Removed "Admin - Tag List" text
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              // Navigate back
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            'Manage',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF8A78B),
                            ),
                            child: Center(
                              child: Text(
                                totalItems.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hi Admin!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Welcome back to your panel.'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tags List',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _showAddTagDialog();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : paginatedTags.isEmpty
                              ? const Center(
                                  child: Text('No tags found'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: paginatedTags.length,
                                  itemBuilder: (context, index) {
                                    final tag = paginatedTags[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEECE5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF8E8E0),
                                          child: Icon(
                                            Icons.label,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        title: Text(
                                          tag.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          tag.description,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                // Navigate to edit tag page
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Delete Tag'),
                                                    content: Text('Are you sure you want to delete ${tag.name}?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          deleteTag(tag.id);
                                                        },
                                                        child: const Text('Delete'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      const SizedBox(height: 16),
                      if (totalPages > 1) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.first_page),
                              onPressed: currentPage > 1
                                  ? () {
                                      setState(() {
                                        currentPage = 1;
                                      });
                                    }
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: currentPage > 1
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                            ),
                            for (int i = 1; i <= totalPages; i++)
                              if (i == 1 ||
                                  i == totalPages ||
                                  (i >= currentPage - 1 && i <= currentPage + 1))
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: i == currentPage
                                        ? Colors.indigo[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          currentPage = i;
                                        });
                                      },
                                      child: Text(
                                        '$i',
                                        style: TextStyle(
                                          color: i == currentPage
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else if ((i == 2 && currentPage > 3) ||
                                  (i == totalPages - 1 && currentPage < totalPages - 2))
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '...',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                    ),
                                ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: currentPage < totalPages
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.last_page),
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
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Page $currentPage of $totalPages (${totalItems} items)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Add bottom padding to prevent overlap (kept for spacing)
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      // Floating action button has been removed
    );
  }
}

// Main app for testing
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tag Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TagListPage(),
    );
  }
}