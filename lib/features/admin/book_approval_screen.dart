import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:mythica/shared/models/writer_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminBookApprovalScreen extends StatefulWidget {
  const AdminBookApprovalScreen({super.key});

  @override
  State<AdminBookApprovalScreen> createState() => _AdminBookApprovalScreenState();
}

class _AdminBookApprovalScreenState extends State<AdminBookApprovalScreen> {
  late Future<List<Book>> _pendingBooksFuture;

  @override
  void initState() {
    super.initState();
    _pendingBooksFuture = _loadPendingBooks();
  }

  Future<List<Book>> _loadPendingBooks() {
    return context.read<WriterProvider>().getPendingBooks();
  }

  Future<void> _refresh() async {
    setState(() {
      _pendingBooksFuture = _loadPendingBooks();
    });
    await _pendingBooksFuture;
  }

  Future<void> _approve(String bookId) async {
    await context.read<WriterProvider>().approveBook(bookId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book approved.')),
    );
    await _refresh();
  }

  Future<void> _reject(String bookId) async {
    await context.read<WriterProvider>().rejectBook(bookId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book rejected.')),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text('Book Approval Queue'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _pendingBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Failed to load pending books: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      'No books pending approval.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: books.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('Author: ${book.authorName}', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text('Status: ${book.status ?? 'pending_approval'}', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _approve(book.id),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Approve'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _reject(book.id),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
