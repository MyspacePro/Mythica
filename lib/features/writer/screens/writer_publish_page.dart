import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:mythica/models/writer_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriterPublishPage extends StatefulWidget {
  const WriterPublishPage({super.key});

  @override
  State<WriterPublishPage> createState() => _WriterPublishPageState();
}

class _WriterPublishPageState extends State<WriterPublishPage> {
  String? _selectedBookId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser;
      if (user != null) {
        await context.read<WriterProvider>().getMyBooks(user.uid);
      }

      if (!mounted) return;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final incomingBookId = args?['bookId']?.toString();
      if (incomingBookId != null && incomingBookId.isNotEmpty) {
        setState(() => _selectedBookId = incomingBookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        title: const Text('Writer Publish Studio'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Consumer<WriterProvider>(
        builder: (context, writer, _) {
          final books = writer.writerBooks;

          if (books.isEmpty) {
            return const Center(
              child: Text('No books available for publish flow.', style: TextStyle(color: Colors.white70)),
            );
          }

          _selectedBookId ??= books.first.id;
          final selectedBook = books.firstWhere(
            (book) => book.id == _selectedBookId,
            orElse: () => books.first,
          );

          final status = selectedBook.status ?? 'draft';
          final chapterCount = writer.chapterCountForBook(selectedBook.id);
          final canSubmit = status == 'draft' || status == 'rejected';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Choose Book', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBookId,
                dropdownColor: const Color(0xFF251A3F),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF251A3F),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                items: books
                    .map(
                      (book) => DropdownMenuItem<String>(
                        value: book.id,
                        child: Text('${book.title} • ${_labelFromStatus(book.status)}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedBookId = value),
              ),
              const SizedBox(height: 20),
              _SummaryCard(book: selectedBook, chapterCount: chapterCount),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: writer.isBookProcessing(selectedBook.id) || !canSubmit || chapterCount == 0
                      ? null
                      : () async {
                          await context.read<WriterProvider>().submitForPublish(selectedBook.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book submitted for approval.')),
                          );
                        },
                  icon: const Icon(Icons.outgoing_mail),
                  label: const Text('Submit Publish Request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C84C),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: writer.isBookProcessing(selectedBook.id) || status != 'approved'
                      ? null
                      : () async {
                          await context.read<WriterProvider>().publishBook(selectedBook.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book moved to published state.')),
                          );
                        },
                  icon: const Icon(Icons.public),
                  label: const Text('Mark as Published (if approved)'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _labelFromStatus(String? status) {
    switch (status) {
      case 'pending_approval':
        return 'Pending Approval';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'published':
        return 'Published';
      default:
        return 'Draft';
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.book, required this.chapterCount});

  final Book book;
  final int chapterCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF251A3F),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Author: ${book.authorName.isNotEmpty ? book.authorName : book.author}', style: const TextStyle(color: Colors.white70)),
            Text('Chapters: $chapterCount', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Current Status: ', style: TextStyle(color: Colors.white70)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C84C).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF5C84C)),
                  ),
                  child: Text(_WriterPublishPageState._labelFromStatus(book.status)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
