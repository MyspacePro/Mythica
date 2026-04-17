import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedGenre = 'Fiction';
  bool _isPremium = false;

  final List<String> _genres = const [
    'Fiction',
    'Romance',
    'Fantasy',
    'Thriller',
    'Horror',
    'Business',
    'Self Growth',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _createBook() async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in again.')),
      );
      return;
    }

    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required.')),
      );
      return;
    }

    final writer = context.read<WriterProvider>();
    final bookId = await writer.createBook(
      title: title,
      authorId: user.uid,
      authorName: user.name,
      description: description,
      genre: _selectedGenre,
      isPremium: _isPremium,
    );

    if (!mounted) return;

    if (bookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(writer.error ?? 'Failed to create book.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book created as draft.')),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.writeChapter,
      arguments: {
        'bookId': bookId,
        'bookTitle': title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        title: const Text('Create Book'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<WriterProvider>(
        builder: (context, writer, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Book Title', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Enter book title'),
                ),
                const SizedBox(height: 16),
                const Text('Description', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Describe your book'),
                ),
                const SizedBox(height: 16),
                const Text('Genre', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  decoration: _inputDecoration('Select genre'),
                  dropdownColor: const Color(0xFF251A3F),
                  items: _genres
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGenre = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _isPremium,
                  onChanged: (value) => setState(() => _isPremium = value),
                  title: const Text('Premium book', style: TextStyle(color: Colors.white)),
                  activeColor: const Color(0xFFF5C84C),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: writer.isActionLoading ? null : _createBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5C84C),
                    ),
                    child: writer.isActionLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'Create Draft Book',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF251A3F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
