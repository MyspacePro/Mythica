import 'package:mythica/features/library/models/library_book.dart';
import 'package:mythica/features/library/models/library_store.dart';
import 'package:mythica/features/reader/screens/pdf_reader_screen.dart';
import 'package:mythica/models/user_model.dart';
import 'package:mythica/models/writer_book_model.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/providers/comment_provider.dart';
import 'package:mythica/providers/follow_provider.dart';
import 'package:mythica/providers/monetization_provider.dart';
import 'package:mythica/shared/widgets/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/data/dummy_books.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  Book? _book;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  void _loadBook() {
    try {
      _book = dummyBooks.firstWhere(
        (b) => b.id == widget.bookId,
        orElse: () => dummyBooks.first,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CommentProvider>().loadComments(widget.bookId);
      });
    } catch (_) {
      _book = null;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_book == null) {
      return const Scaffold(
        body: Center(child: Text("Book not found")),
      );
    }

    final book = _book!;

    /// ✅ FIXED existingBook logic
    final existingBook = LibraryStore.instance.books
        .where((b) => b.id == book.id)
        .cast<LibraryBook?>()
        .isNotEmpty
        ? LibraryStore.instance.books.firstWhere((b) => b.id == book.id)
        : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B2FF7), Color(0xFF9F44D3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reader Tail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

          /// body
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 120),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: book.coverImage.startsWith("http")
                                ? Image.network(
                                    book.coverImage,
                                    height: 180,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    book.coverImage,
                                    height: 180,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    '⭐ ${book.rating.toStringAsFixed(1)} (${book.reviewCount} reviews)'),
                                const SizedBox(height: 6),
                                Text('By ${book.authorName}',
                                    style: const TextStyle(
                                        color: Colors.black54)),
                                const SizedBox(height: 6),
                                Text(
                                    '${book.genre} • ${book.viewsCount} views',
                                    style: const TextStyle(
                                        color: Colors.black54)),
                                const SizedBox(height: 12),
                                _FollowButton(book: book),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        book.description,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      if (book.isPaid)
                        Text(
                          'Paid Book • ₹${book.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),

                      const SizedBox(height: 16),

                      /// READ / PURCHASE BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple),
                          child: Text(book.isPaid
                              ? 'Purchase'
                              : (existingBook == null
                                  ? 'Read Now'
                                  : 'Continue')),
                          onPressed: () async {
                            /// paid book
                            if (book.isPaid) {
                              try {
                                final user = context
                                    .read<AuthProvider>()
                                    .currentUser;

                                await context
                                    .read<MonetizationProvider>()
                                    .purchaseBook(
                                      buyerId:
                                          user?.uid ?? 'reader_local',
                                      buyerName:
                                          user?.name ?? 'Reader',
                                      bookId: book.id,
                                    );

                                if (!mounted) return;

                                showAppPopup(
                                  context: context,
                                  title: 'Purchase Successful',
                                  message:
                                      'Book added to your account.',
                                  buttonText: 'Great',
                                );
                              } catch (e) {
                                if (!mounted) return;

                                showAppPopup(
                                  context: context,
                                  title: 'Error',
                                  message: e.toString(),
                                  buttonText: 'OK',
                                );
                              }

                              return;
                            }

                            /// create reader book
                            final LibraryBook readerBook =
                                existingBook ??
                                    LibraryBook(
                                      id: book.id,
                                      author: book.author,
                                      title: book.title,
                                      category: book.genre,
                                      pdfPath: book.pdfPath,
                                      imagePath: book.coverImage,
                                      chapters: book.chapters,
                                    );

                            if (existingBook == null) {
                              LibraryStore.instance
                                  .addBook(readerBook);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PdfReaderScreen(book: readerBook),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Comments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      _CommentsSection(
                          book: book,
                          controller: _commentController),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, FollowProvider>(
      builder: (context, auth, follow, _) {
        final user = auth.currentUser;

        final isFollowing = follow.isFollowing(
          readerId: user?.uid ?? 'reader_1',
          writerId: book.authorId,
        );

        return OutlinedButton(
          child: Text(isFollowing ? 'Following' : 'Follow'),
          onPressed: () async {
            try {
              final current = user ??
                  AppUser(
                    uid: 'reader_1',
                    email: 'reader@demo.com',
                    name: 'Demo Reader',
                    phone: '',
                    city: '',
                    gender: 'unknown',
                    role: UserRole.reader,
                    currentMode: UserMode.reader,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    hasCompletedOnboarding: true,
                    selectedGenres: const [],
                    favoriteGenres: const [],
                    hasActiveSubscription: false,
                  );

              await follow.toggleFollow(
                currentUser: current,
                writerId: book.authorId,
                writerName: book.authorName,
              );
            } catch (e) {
              if (!context.mounted) return;

              showAppPopup(
                context: context,
                title: 'Notice',
                message: e.toString(),
                buttonText: 'OK',
              );
            }
          },
        );
      },
    );
  }
}

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({
    required this.book,
    required this.controller,
  });

  final Book book;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommentProvider, AuthProvider>(
      builder: (context, comments, auth, _) {
        final items = comments.commentsForBook(book.id);

        return Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Write a comment',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) return;

                    try {
                      final user =
                          auth.currentUser ??
                              AppUser(
                                uid: 'reader_1',
                                email: 'reader@demo.com',
                                name: 'Demo Reader',
                                phone: '',
                                city: '',
                                gender: 'unknown',
                                role: UserRole.reader,
                                currentMode: UserMode.reader,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                hasCompletedOnboarding: true,
                                selectedGenres: const [],
                                favoriteGenres: const [],
                                hasActiveSubscription: false,
                              );

                      await comments.addComment(
                        bookId: book.id,
                        authorId: book.authorId,
                        user: user,
                        commentText: controller.text.trim(),
                      );

                      controller.clear();
                    } catch (e) {
                      if (!context.mounted) return;

                      showAppPopup(
                        context: context,
                        title: 'Error',
                        message: e.toString(),
                        buttonText: 'OK',
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No comments yet'),
              )
            else
              ...items.take(5).map(
                    (c) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/profile/male.png'),
                      ),
                      title: Text(c.userName),
                      subtitle: Text(c.commentText),
                      trailing: Text(
                          '${c.createdAt.hour}:${c.createdAt.minute.toString().padLeft(2, '0')}'),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
