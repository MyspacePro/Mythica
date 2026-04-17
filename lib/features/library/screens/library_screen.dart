import 'package:mythica/features/book/screens/booklist.dart';
import 'package:mythica/features/library/models/library_book.dart';
import 'package:flutter/material.dart';
import '../widgets/library_books_grid.dart';
import 'package:mythica/core/routes/app_routes.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  // 🎨 Luxury Color System
  static const Color bgTop = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgBottom = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

 
  List<LibraryBook> get myBooksList => LibraryData.demoBooks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgMid, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            /// 🔥 PARALLAX HERO BANNER
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: bgTop,
              elevation: 0,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final percent =
                      (constraints.maxHeight - kToolbarHeight) / 200;

                  return Stack(
                    fit: StackFit.expand,
                    children: [

                      /// Background Image (Parallax)
                      Transform.translate(
                        offset: Offset(0, percent * -30),
                        child: Image.asset(
                          "assets/books/Book1.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// Luxury Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              bgBottom.withValues(alpha:0.85),
                              bgBottom,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      /// Banner Content
                      Positioned(
                        left: 24,
                        bottom: 44,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Featured Book",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "The Silent Reader",
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 14),

                            /// 🔥 Premium Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gold,
                                foregroundColor: bgTop,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                elevation: 0,
                                shadowColor:
                                    goldGlow.withValues(alpha:0.3),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.bookDetail,
                                );
                              },
                              child: const Text(
                                "Continue Reading",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            /// CONTINUE READING
            SliverToBoxAdapter(
              child: _sectionTitle("Continue Reading"),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.bookDetail,
                        );
                      },
                      child: AnimatedScale(
                        duration:
                            const Duration(milliseconds: 150),
                        scale: 1.0,
                        child: _continueCard(
                          "assets/books/Book${index + 1}.png",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// CATEGORIES
            SliverToBoxAdapter(
              child: _sectionTitle("Categories"),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _CategoryChip(label: "All"),
                    _CategoryChip(label: "Reading"),
                    _CategoryChip(label: "Completed"),
                    _CategoryChip(label: "Saved"),
                    _CategoryChip(label: "Premium"),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            /// BOOK GRID
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverFillRemaining(
                hasScrollBody: true,
                child: LibraryBooksGrid(books:myBooksList,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
    );
  }

  Widget _continueCard(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderInactive),
        boxShadow: [
          BoxShadow(
            color: goldGlow.withValues(alpha:0.25),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: 130,
              fit: BoxFit.cover,
            ),

            /// Progress bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 6,
                color: borderInactive,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Container(
                    color: gold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF251A3F),
              content: Text(
                '$label filter coming soon',
                style: const TextStyle(
                  color: Color(0xFFCFC8E8),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF251A3F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(0xFF3A2D5C)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFCFC8E8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}