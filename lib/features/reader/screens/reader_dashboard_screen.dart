import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/reader/controller/reader_controller.dart';
import 'package:mythica/features/reader/models/reader_book_model.dart';
import 'package:mythica/features/reader/provider/reader_studio_provider.dart';
import 'package:mythica/features/reader/screens/reader_screen.dart';
import 'package:mythica/features/reader/widgets/continue_reading_list.dart';
import 'package:mythica/features/reader/widgets/reader_analytics_widget.dart';
import 'package:mythica/features/reader/widgets/reader_recommended_books_grid.dart';
import 'package:mythica/features/reader/widgets/reader_section.dart';
import 'package:mythica/features/reader/widgets/reader_stats_grid.dart';
import 'package:mythica/features/reader/widgets/reading_task_section.dart';
import 'package:mythica/shared/widgets/app_popup.dart';
import 'package:mythica/features/reader/screens/coins_screen.dart';
import '../widgets/reader_header.dart';

class ReaderDashboardScreen extends StatefulWidget {
  const ReaderDashboardScreen({super.key});

  @override
  State<ReaderDashboardScreen> createState() =>
      _ReaderDashboardScreenState();
}

class _ReaderDashboardScreenState extends State<ReaderDashboardScreen> {
  static const double _horizontalPadding = 20;

  final ReaderController _readerController = ReaderController();

  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgEnd = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardSoft = Color(0xFF2E224F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _readerController.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    _isLoading = true;

    final authProvider = context.read<AuthProvider>();
    final studioProvider = context.read<ReaderStudioProvider>();
    

    try {
      if (!authProvider.isLoggedIn) {
        if (!mounted) return;
        await showAppPopup(
          context: context,
          title: 'Login Required',
          message: 'Login to access Reader Studio features',
          buttonText: 'OK',
        );
        return;
      }

      await studioProvider.loadDashboard(
        userId: authProvider.currentUser?.uid,
      );
      studioProvider.loadTasks();
      final error = studioProvider.errorMessage;

      if (error != null && mounted) {
        await showAppPopup(
          context: context,
          title: 'Something went wrong',
          message: error,
          buttonText: 'Close',
        );
      }
    } catch (_) {
      if (!mounted) return;
      await showAppPopup(
        context: context,
        title: 'Error',
        message: 'Failed to load dashboard. Please try again.',
        buttonText: 'Close',
      );
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _readerController.dispose();
    super.dispose();
  }
/// ✅ COINS SCREEN
  void _openCoinsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReaderCoinScreen(),
      ),
    );
  }
  void _openPdfReader(ReaderBookModel book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(isLocked: false, book: book),
      ),
    );
  }

  void _openAnalytics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReaderScreen(isLocked: false),
      ),
    );
  }

  Future<void> _toggleBookmark(ReaderBookModel book) async {
    try {
      await context.read<ReaderStudioProvider>().toggleBookmark(
            bookId: book.id,
            userId: context.read<AuthProvider>().currentUser?.uid,
          );
    } catch (_) {
      if (!mounted) return;
      await showAppPopup(
        context: context,
        title: 'Action failed',
        message: 'Unable to update bookmark right now.',
        buttonText: 'Close',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    final horizontalPadding =
        width > 1000 ? width * 0.12 : _horizontalPadding;

    return Consumer<ReaderStudioProvider>(
      builder: (context, studioProvider, _) {

         /// ✅ TASK LOGIC
        final tasks = studioProvider.readingTasks;
        final completedTasks =
            tasks.where((e) => e.isCompleted).length;
        final totalTasks = tasks.length;

        final double progress =
            totalTasks == 0 ? 0 : completedTasks / totalTasks;

        final continueReadingBooks =
            studioProvider.getContinueReading();
        final recentlyReadBooks =
            studioProvider.getRecentlyRead();
        final favoriteBooks =
            studioProvider.getQuickAccessFavorites();

        final featuredBooks = favoriteBooks.isNotEmpty
            ? favoriteBooks
            : recentlyReadBooks;

        final recommendedBooks =
            studioProvider.getRecommendedBooks();

        return Scaffold(
          backgroundColor: bgPrimary,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [bgPrimary, bgMid, bgEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                color: gold,
                backgroundColor: cardFill,
                onRefresh: _loadData,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const ReaderHeader(),

                            SizedBox(height: height * 0.03),

                            /// STATS
                            Container(
                              decoration: BoxDecoration(
                                color: cardSoft,
                                borderRadius:
                                    BorderRadius.circular(28),
                                border: Border.all(
                                    color: borderInactive),
                                boxShadow: [
                                  BoxShadow(
                                    color: goldGlow
                                        .withValues(alpha: 0.15),
                                    blurRadius: 25,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding:
                                  EdgeInsets.all(width * 0.05),
                              child: AnimatedBuilder(
                                animation: _readerController,
                                builder: (context, _) {
                                  return ReaderStatsGrid(
                                    controller:
                                        _readerController,
                                    onTap: _openAnalytics,
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            

                            /// ANALYTICS
                            Container(
                              decoration: BoxDecoration(
                                color: cardSoft,
                                borderRadius:
                                    BorderRadius.circular(26),
                                border: Border.all(
                                    color: borderInactive),
                              ),
                              padding:
                                  EdgeInsets.all(width * 0.045),
                              child: ReaderAnalyticsWidget(
                                onTap: _openAnalytics,
                              ),
                            ),

                            SizedBox(height: height * 0.045),
                          ],
                        ),
                      ),
                    ),

                    /// LOADING / EMPTY / CONTENT
                    if (studioProvider.isLoading)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: gold,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    else if (studioProvider.allBooks.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'No Reader Studio data found.',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const ReaderSectionTitle(
                                  title: 'Continue Reading'),
                              ContinueReadingSlider(
                                books: continueReadingBooks,
                                onBookTap: _openPdfReader,
                                onBookLongPress:
                                    _toggleBookmark,
                              ),

                              SizedBox(height: height * 0.04),

                              const ReaderSectionTitle(
                                  title: 'Featured Books'),
                              ContinueReadingSlider(
                                books: featuredBooks,
                                onBookTap: _openPdfReader,
                                onBookLongPress:
                                    _toggleBookmark,
                              ),

                              SizedBox(height: height * 0.04),

                              const ReaderSectionTitle(
                                  title:
                                      'Recommended For You'),
                              RecommendedBooksGrid(
                                books: recommendedBooks,
                                onBookTap: _openPdfReader,
                                onBookLongPress:
                                    _toggleBookmark,
                              ),

                              SizedBox(height: height * 0.04),
                            ],
                          ),
                        ),
                      ),

                      /// ✅ COINS CLICK
                            GestureDetector(
                              onTap: _openCoinsScreen,
                              child: AnimatedBuilder(
                                animation: _readerController,
                                builder: (_, __) {
                                  return ReaderStatsGrid(
                                    controller:
                                        _readerController,
                                    onTap: _openCoinsScreen,
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            ReaderAnalyticsWidget(
                              onTap: _openAnalytics,
                            ),

                            SizedBox(height: height * 0.04),
                                              
                      
                   
                  /// TASK SECTION
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const ReaderSectionTitle(
                                title: 'Reading Tasks'),
                            Container(
                              decoration: BoxDecoration(
                                color: cardSoft,
                                borderRadius:
                                    BorderRadius.circular(24),
                                border: Border.all(
                                    color: borderInactive),
                              ),
                              padding:
                                  EdgeInsets.all(width * 0.045),
                              child: ReadingTaskSection(
                                progress: progress,
                              completedTasks: completedTasks,
                              totalTasks: totalTasks,
                              tasks: tasks,
                                onTaskTap: (_) =>
                                    _openAnalytics(),
                              ),
                            ),

                            SizedBox(height: height * 0.07),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}