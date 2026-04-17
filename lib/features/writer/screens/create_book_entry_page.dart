import 'dart:async';
import 'package:mythica/features/writer/services/content_moderation_service.dart' show ModerationStatus, ContentModerationService;
import 'package:flutter/material.dart';
import 'package:mythica/core/routes/app_routes.dart';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _chapterTitleController = TextEditingController();
  final TextEditingController _chapterContentController = TextEditingController();

  List<Map<String, String>> _chapters = [];

  Timer? _autoSaveTimer;
  bool _isSaved = true;

  Map<String, dynamic>? _bookArgs;

  int get _wordCount {
    if (_chapterContentController.text.trim().isEmpty) return 0;
    return _chapterContentController.text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    _startAutoSave();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _bookArgs = args;
        final incomingTitle = args['title'] as String?;
        if (incomingTitle != null && incomingTitle.isNotEmpty) {
          _bookTitleController.text = incomingTitle;
        }
      }
    });
  }

  void _startAutoSave() {
    _autoSaveTimer =
        Timer.periodic(const Duration(seconds: 8), (_) => _saveDraft());
  }

  void _saveDraft() {
    if (!_isSaved) {
      setState(() => _isSaved = true);
    }
  }

  void _onTextChanged() {
    if (_isSaved) {
      setState(() => _isSaved = false);
    }
  }

  /// 🔎 Moderation before adding chapter
  Future<void> _addOrUpdateChapter() async {
    final title = _chapterTitleController.text.trim();
    final content = _chapterContentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    final result = await ContentModerationService.checkContent(
      _bookTitleController.text,
      title,
      content,
    );

    if (!mounted) return;

    if (result.status == ModerationStatus.blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Content blocked: ${result.matchedKeyword ?? result.message}"),
        ),
      );
      return;
    }

    if (result.status == ModerationStatus.warning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Warning: ${result.message}"),
        ),
      );
    }

    setState(() {
      _chapters.add({'title': title, 'content': content});
      _chapterTitleController.clear();
      _chapterContentController.clear();
      _isSaved = false;
    });

    _saveDraft();
  }

  void _editChapter(int index) {
    final chapter = _chapters[index];
    _chapterTitleController.text = chapter['title'] ?? "";
    _chapterContentController.text = chapter['content'] ?? "";

    setState(() {
      _chapters.removeAt(index);
    });
  }

  void _deleteChapter(int index) {
    setState(() {
      _chapters.removeAt(index);
      _isSaved = false;
    });
  }

  /// 🔎 Full book moderation before publish
  Future<void> _publishBook() async {
    final title = _bookTitleController.text.trim();

    if (title.isEmpty || _chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add book title & at least one chapter"),
        ),
      );
      return;
    }

    String fullContent = "";
    for (final chapter in _chapters) {
      fullContent += " ${chapter['title']} ${chapter['content']}";
    }

    final result = await ContentModerationService.checkContent(
      title,
      "",
      fullContent,
    );

    if (!mounted) return;

    if (result.status == ModerationStatus.blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Book cannot be published. Restricted content detected."),
        ),
      );
      return;
    }

    if (result.status == ModerationStatus.warning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Warning: ${result.message}"),
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Entry saved successfully 🚀")),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.writeChapter,
      arguments: {
        ...?_bookArgs,
        'bookTitle': title,
        'chapters': _chapters,
      },
    );
  }

  void _reorderChapter(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _chapters.removeAt(oldIndex);
      _chapters.insert(newIndex, item);
      _isSaved = false;
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _bookTitleController.dispose();
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [

              /// TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFFF5C84C)),
                    ),
                    const Spacer(),
                    Icon(
                      _isSaved ? Icons.check_circle : Icons.sync_problem,
                      color: _isSaved
                          ? const Color(0xFFF5C84C)
                          : const Color(0xFFE6B93E),
                      size: 20,
                    ),
                  ],
                ),
              ),

              /// MAIN CARD
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFF3A2D5C),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Create New Book",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),

                        const SizedBox(height: 28),

                        _luxuryInput(_bookTitleController, "Book Title"),
                        const SizedBox(height: 18),

                        _luxuryInput(_chapterTitleController, "Chapter Title"),
                        const SizedBox(height: 18),

                        _luxuryInput(
                            _chapterContentController,
                            "Write chapter here...",
                            maxLines: 6),
                        const SizedBox(height: 10),

                        Text(
                          "Word Count: $_wordCount",
                          style: const TextStyle(
                            color: Color(0xFF9F96C8),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _addOrUpdateChapter,
                            child: const Text("Add Chapter"),
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "Chapters",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 180,
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _chapters.length,
                            onReorder: _reorderChapter,
                            itemBuilder: (context, index) {
                              final chapter = _chapters[index];

                              return Container(
                                key: ValueKey(chapter),
                                width: 170,
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF251A3F),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                      color: const Color(0xFF3A2D5C)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chapter['title'] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              size: 18,
                                              color: Color(0xFFF5C84C)),
                                          onPressed: () =>
                                              _editChapter(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18,
                                              color: Color(0xFFE6B93E)),
                                          onPressed: () =>
                                              _deleteChapter(index),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _publishBook,
                            child: const Text(
                              "Publish Book",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _luxuryInput(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => _onTextChanged(),
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
        filled: true,
        fillColor: const Color(0xFF251A3F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Color(0xFF3A2D5C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Color(0xFFF5C84C)),
        ),
      ),
    );
  }
}