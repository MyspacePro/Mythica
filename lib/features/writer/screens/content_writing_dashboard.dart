import 'package:flutter/material.dart';

class ContentWritingDashboard extends StatefulWidget {
  const ContentWritingDashboard({Key? key}) : super(key: key);

  @override
  State<ContentWritingDashboard> createState() =>
      _ContentWritingDashboardState();
}

class _ContentWritingDashboardState extends State<ContentWritingDashboard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String selectedCategory = "Short Story";

  final List<String> categories = [
    "Short Story",
    "Unique Notes",
    "Quotes",
    "Social Media Content",
    "Web Series Script",
    "Movie Story",
    "Kids Story",
  ];

  /// dispose controllers
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Bottom Navigation Logic
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.pushNamed(context, "/books");
        break;

      case 2:
        Navigator.pushNamed(context, "/analytics");
        break;

      case 3:
        Navigator.pushNamed(context, "/profile");
        break;
    }
  }

  /// Validate Input
  bool _validateInput() {
    if (_titleController.text.trim().isEmpty) {
      _showSnack("Title required");
      return false;
    }

    if (_contentController.text.trim().isEmpty) {
      _showSnack("Content required");
      return false;
    }

    return true;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF251A3F),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFCFC8E8)),
        ),
      ),
    );
  }

  /// Save Draft Logic
  void _saveDraft() {
    if (!_validateInput()) return;

    Navigator.pop(context);

    _titleController.clear();
    _contentController.clear();

    _showSnack("Draft saved successfully");
  }

  /// Publish Logic
  void _publishContent() {
    if (!_validateInput()) return;

    Navigator.pop(context);

    _titleController.clear();
    _contentController.clear();

    _showSnack("Content published successfully!");
  }

  void _openWriterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1533),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1F1533),
                Color(0xFF2A1E47),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create New Content",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// Category
                  _luxuryInput(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF251A3F),
                      value: selectedCategory,
                      style: const TextStyle(color: Color(0xFFCFC8E8)),
                      items: categories
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Category",
                        labelStyle: TextStyle(color: Color(0xFF9F96C8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  _luxuryInput(
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Color(0xFFFFFFFF)),
                      decoration: const InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Color(0xFF9F96C8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Content
                  _luxuryInput(
                    child: TextField(
                      controller: _contentController,
                      maxLines: 8,
                      style: const TextStyle(color: Color(0xFFCFC8E8)),
                      decoration: const InputDecoration(
                        labelText: "Write your content here...",
                        labelStyle: TextStyle(color: Color(0xFF9F96C8)),
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _saveDraft,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFCFC8E8),
                            side: const BorderSide(color: Color(0xFF3A2D5C)),
                            backgroundColor: const Color(0xFF251A3F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text("Save as Draft"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _publishContent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5C84C),
                            foregroundColor: const Color(0xFF1F1533),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ).copyWith(
                            shadowColor: MaterialStateProperty.all(
                              const Color(0xFFFFD76A).withValues(alpha:0.3),
                            ),
                          ),
                          child: const Text(
                            "Publish",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _luxuryInput({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Greeting
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Evening, Aryan",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Ready to continue your story?",
                          style: TextStyle(color: Color(0xFF9F96C8)),
                        )
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xFF251A3F),
                      child: Icon(Icons.person, color: Color(0xFFF5C84C)),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Quick Content Creation",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF)),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Write short stories, quotes, scripts, movie plots, kids stories & social media content.",
                        style: TextStyle(color: Color(0xFFCFC8E8)),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _openWriterSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5C84C),
                          foregroundColor: const Color(0xFF1F1533),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Start Writing"),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF5C84C),
        foregroundColor: const Color(0xFF1F1533),
        onPressed: _openWriterSheet,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF251A3F),
        selectedItemColor: const Color(0xFFF5C84C),
        unselectedItemColor: const Color(0xFF9F96C8),
        currentIndex: 0,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}