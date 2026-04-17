import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/features/reader/provider/reader_provider.dart';
import 'package:mythica/features/library/models/library_book.dart';
import 'package:mythica/features/subscription/reader_subscription_screen.dart';

class BookReaderScreen extends StatefulWidget {
  final LibraryBook book;
  final bool isLocked;

  const BookReaderScreen({
    super.key,
    required this.book,
    this.isLocked = false,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late final List<String> chapters;

  @override
  void initState() {
    super.initState();

    /// fallback chapters
    chapters = widget.book.chapters.isNotEmpty
        ? widget.book.chapters
        : List.generate(
            10,
            (index) =>
                "Chapter ${index + 1}\n\nThis is demo content.\n\nSwipe to continue reading.",
          );

    if (!widget.isLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final reader = context.read<ReaderProvider>();

        reader.loadBook(
          bookId: widget.book.id,
          totalChapters: chapters.length,
          lastReadChapter: widget.book.lastReadChapter,
        );

        if (reader.pageController.hasClients) {
          reader.pageController.jumpToPage(
            widget.book.lastReadChapter.clamp(0, chapters.length - 1),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    if (!widget.isLocked) {
      context.read<ReaderProvider>().saveProgress(widget.book.id);
    }
    super.dispose();
  }

  /// THEME
  (Color, Color) _theme(ReaderProvider p) {
    switch (p.themeMode) {
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
    return Consumer<ReaderProvider>(
      builder: (context, reader, _) {
        final (bg, text) = _theme(reader);

        final progress = reader.totalChapters == 0
            ? 0.0
            : (reader.currentChapter + 1) / reader.totalChapters;

        final location = reader.currentChapter.toString();

        return Scaffold(
          backgroundColor: bg,

          /// APPBAR
          appBar: reader.showControls
              ? AppBar(
                  backgroundColor: bg,
                  elevation: 0,
                  iconTheme: IconThemeData(color: text),
                  title: Text(widget.book.title,
                      style: TextStyle(color: text)),
                  actions: [
                    /// BOOKMARK
                    IconButton(
                      icon: Icon(
                        reader.isBookmarked(location)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: text,
                      ),
                      onPressed: widget.isLocked
                          ? null
                          : () async {
                              await reader.toggleBookmark(location);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    reader.isBookmarked(location)
                                        ? "Bookmark added"
                                        : "Bookmark removed",
                                  ),
                                ),
                              );
                            },
                    ),

                    /// THEME
                    PopupMenuButton<ReaderThemeMode>(
                      icon: Icon(Icons.color_lens, color: text),
                      onSelected: reader.changeTheme,
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: ReaderThemeMode.light,
                            child: Text("Light")),
                        PopupMenuItem(
                            value: ReaderThemeMode.dark,
                            child: Text("Dark")),
                        PopupMenuItem(
                            value: ReaderThemeMode.sepia,
                            child: Text("Sepia")),
                      ],
                    ),

                    /// FONT
                    PopupMenuButton<String>(
                      icon: Icon(Icons.text_fields, color: text),
                      onSelected: (v) {
                        if (v == "inc") {
                          reader.increaseFont();
                        } else {
                          reader.decreaseFont();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: "inc", child: Text("Increase Font")),
                        PopupMenuItem(
                            value: "dec", child: Text("Decrease Font")),
                      ],
                    ),
                  ],
                )
              : null,

          /// BODY
          body: widget.isLocked
              ? _lockedView(context)
              : GestureDetector(
                  onTap: reader.toggleControls,
                  child: Column(
                    children: [
                      /// PROGRESS BAR
                      if (reader.showControls)
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.deepPurple,
                        ),

                      /// PAGE VIEW
                      Expanded(
                        child: PageView.builder(
                          controller: reader.pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: chapters.length,
                          onPageChanged: (i) => reader.onPageChanged(i),
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: SingleChildScrollView(
                                child: Text(
                                  chapters[i],
                                  style: TextStyle(
                                    fontSize: reader.fontSize,
                                    height: 1.7,
                                    color: text,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

          /// BOTTOM BAR
          bottomNavigationBar: widget.isLocked
              ? null
              : reader.showControls
                  ? Container(
                      color: bg,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          /// PREVIOUS
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: text),
                            onPressed: reader.currentChapter > 0
                                ? reader.previousChapter
                                : null,
                          ),

                          /// TTS
                          IconButton(
                            icon: Icon(
                              reader.isSpeaking
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: text,
                            ),
                            onPressed: () {
                              reader.setSpeaking(!reader.isSpeaking);
                            },
                          ),

                          /// NEXT
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: text),
                            onPressed: reader.currentChapter <
                                    reader.totalChapters - 1
                                ? reader.nextChapter
                                : null,
                          ),
                        ],
                      ),
                    )
                  : null,
        );
      },
    );
  }

  /// LOCKED UI
  Widget _lockedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 70, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Premium Content",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Subscribe to unlock this book",
                textAlign: TextAlign.center),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text("Subscribe Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ReaderSubscriptionScreen(),
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