import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteChapterScreen extends StatefulWidget {
  const WriteChapterScreen({super.key});

  @override
  State<WriteChapterScreen> createState() => _WriteChapterScreenState();
}

class _WriteChapterScreenState extends State<WriteChapterScreen> {
  final _chapterTitleController = TextEditingController();
  final _chapterContentController = TextEditingController();

  @override
  void dispose() {
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    super.dispose();
  }

  Future<void> _saveChapter() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final bookId = args['bookId']?.toString();
    final chapterId = args['chapterId']?.toString();
    final title = _chapterTitleController.text.trim();
    final content = _chapterContentController.text.trim();

    if (bookId == null || bookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing book context. Re-open from Create Book.')),
      );
      return;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill chapter title and content.')),
      );
      return;
    }

    final writer = context.read<WriterProvider>();

    final moderation = await writer.validateContentSafety(
      title: title,
      description: args['bookTitle']?.toString() ?? '',
      content: content,
    );

    if (!mounted) return;

    if (moderation.status.name == 'blocked') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chapter contains blocked content.')),
      );
      return;
    }

    if (chapterId != null && chapterId.isNotEmpty) {
      await writer.updateChapter(chapterId: chapterId, title: title, content: content);
    } else {
      await writer.addChapter(
        bookId: bookId,
        title: title,
        content: content,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter saved to draft.')),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.writerPublish,
      arguments: {
        ...args,
        'bookId': bookId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final bookTitle = args['bookTitle']?.toString() ?? 'Book';
    final bookId = args['bookId']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Write Chapter • $bookTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _chapterTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Chapter title',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _chapterContentController,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Chapter content',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Consumer<WriterProvider>(
              builder: (context, writer, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: writer.isBookProcessing(bookId) ? null : _saveChapter,
                    icon: writer.isBookProcessing(bookId)
                        ? const SizedBox.shrink()
                        : const Icon(Icons.save),
                    label: writer.isBookProcessing(bookId)
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: CircularProgressIndicator(color: Colors.black),
                          )
                        : const Text('Save Draft Chapter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5C84C),
                      foregroundColor: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
