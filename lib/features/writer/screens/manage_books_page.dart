import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:mythica/models/writer_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageBooksPage extends StatefulWidget {
  const ManageBooksPage({super.key});

  @override
  State<ManageBooksPage> createState() => _ManageBooksPageState();
}

class _ManageBooksPageState extends State<ManageBooksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser;
      if (user != null) {
        context.read<WriterProvider>().getMyBooks(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentUser = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        title: const Text('Manage Books'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<WriterProvider>(
        builder: (context, writer, _) {
          if (writer.isLoading && writer.writerBooks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (writer.writerBooks.isEmpty) {
            return const Center(
              child: Text('No books yet. Create your first draft.', style: TextStyle(color: Colors.white70)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (currentUser != null) {
                await context.read<WriterProvider>().getMyBooks(currentUser.uid);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: writer.writerBooks.length,
              itemBuilder: (context, index) {
                final book = writer.writerBooks[index];
                return _BookTile(book: book);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createBook),
        label: const Text('Create Book'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final writer = context.watch<WriterProvider>();
    final chapterCount = writer.chapterCountForBook(book.id);
    final isBusy = writer.isBookProcessing(book.id);

    return Card(
      color: const Color(0xFF251A3F),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text('Total Chapters: $chapterCount', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(color: Colors.white70)),
                _StatusChip(status: book.status ?? 'draft'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isBusy
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.writeChapter,
                              arguments: {
                                'bookId': book.id,
                                'bookTitle': book.title,
                              },
                            );
                          },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isBusy || (book.status == 'pending_approval') || chapterCount == 0
                        ? null
                        : () async {
                            await context.read<WriterProvider>().submitForPublish(book.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Submitted for admin approval.')),
                            );
                          },
                    icon: const Icon(Icons.publish),
                    label: const Text('Publish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    Color color;
    String label;

    switch (normalized) {
      case 'pending_approval':
        color = Colors.orange;
        label = 'Pending Approval';
        break;
      case 'approved':
        color = Colors.green;
        label = 'Approved';
        break;
      case 'rejected':
        color = Colors.redAccent;
        label = 'Rejected';
        break;
      case 'published':
        color = Colors.tealAccent;
        label = 'Published';
        break;
      default:
        color = Colors.blueGrey;
        label = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
