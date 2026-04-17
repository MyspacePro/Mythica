import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mythica/features/reader/controller/reader_controller.dart';
import 'package:mythica/features/reader/models/reader_book_model.dart';
import 'package:mythica/features/reader/provider/reader_provider.dart';
import 'package:mythica/features/subscription/reader_subscription_screen.dart';

class ReaderScreen extends StatefulWidget {
  final bool isLocked;
  final ReaderBookModel? book;

  const ReaderScreen({
    super.key,
    required this.isLocked,
    this.book,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  final ReaderController _readerController = ReaderController();

  double _progress = 0;
  bool _isInitialized = false;

  final String _dummyContent = """
📖 Book content starts here...

This is a professional reader experience.

You can change font size, switch themes, and track your reading progress.

Later API / PDF / text will load here.

Keep scrolling to see progress change.

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

End of sample content.
""";

  @override
  void initState() {
    super.initState();
    _readerController.init();

    _scrollController.addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReader();
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (!position.hasPixels || position.maxScrollExtent <= 0) return;

    final progress = (position.pixels / position.maxScrollExtent) * 100;

    if ((progress - _progress).abs() < 0.5) return;

    setState(() {
      _progress = progress.clamp(0, 100);
    });

    final activeBook = widget.book;
    if (activeBook != null) {
      _readerController.updateReadingProgress(
        bookId: activeBook.id,
        progress: _progress,
        pagesRead: 1,
      );
    }
  }

  Future<void> _initializeReader() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final provider = context.read<ReaderProvider>();
    final book = widget.book;

    try {
      if (book == null) {
        await provider.openBook(
          book: const ReaderBookModel(
            id: 'demo_reader_book',
            title: 'Reader Demo',
            description: 'Demo content',
            authorName: 'System',
            coverUrl: '',
            genre: 'Demo',
            rating: 5,
            totalChapters: 1,
            lastReadChapter: 1,
            progressPercent: 0,
            viewsCount: 0,
            isBookmarked: false,
            lastReadAt: null,
          ),
          content: _dummyContent,
        );
      } else {
        await _readerController.openBook(book);
      }
    } catch (_) {
      // silent fail (production safe)
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    _readerController.dispose();
    super.dispose();
  }

  (Color, Color) _resolveTheme(ReaderProvider provider) {
    switch (provider.themeMode) {
      case ReaderThemeMode.dark:
        return (Colors.black, Colors.white);
      case ReaderThemeMode.sepia:
        return (const Color(0xFFF4ECD8), Colors.brown);
      case ReaderThemeMode.light:
        return (Colors.white, Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLocked) {
      return const ReaderSubscriptionScreen();
    }

    return Consumer<ReaderProvider>(
      builder: (context, provider, _) {
        final (bgColor, textColor) = _resolveTheme(provider);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
            title: Text(
              provider.currentBook?.title ?? "Reader",
              style: TextStyle(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.dark_mode, color: textColor),
                onPressed: () =>
                    provider.changeTheme(ReaderThemeMode.dark),
              ),
              IconButton(
                icon: Icon(Icons.menu_book, color: textColor),
                onPressed: () =>
                    provider.changeTheme(ReaderThemeMode.sepia),
              ),
              IconButton(
                icon: Icon(Icons.light_mode, color: textColor),
                onPressed: () =>
                    provider.changeTheme(ReaderThemeMode.light),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth > 800 ? constraints.maxWidth * 0.15 : 20.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: SelectableText(
                      provider.currentBookContent.isEmpty
                          ? _dummyContent
                          : provider.currentBookContent,
                      style: TextStyle(
                        fontSize: provider.fontSize,
                        height: 1.8,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              color: provider.themeMode == ReaderThemeMode.dark
                  ? Colors.grey[900]
                  : Colors.black87,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: provider.decreaseFont,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${_progress.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: provider.increaseFont,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}