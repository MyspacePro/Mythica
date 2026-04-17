import 'package:mythica/features/book/screens/book_detail_screen.dart';
import 'package:mythica/features/services/Favoritebookcard.dart' show FavoriteBookCard;
import 'package:mythica/features/book/model/book_model.dart';
import 'package:mythica/features/library/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesDashboard extends StatefulWidget {
  const FavoritesDashboard({Key? key}) : super(key: key);

  @override
  State<FavoritesDashboard> createState() => _FavoritesDashboardState();
}

class _FavoritesDashboardState extends State<FavoritesDashboard> {
  int selectedFilter = 0;

  final List<String> filters = [
    "All",
    "Recently Added",
    "Most Read",
    "Downloaded"
  ];

  /// 🎨 Colors
  static const Color bgTop = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgBottom = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTop,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgMid, bgBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favoriteBooks =
                  _applyFilter(favoritesProvider.favoriteBooks);

              final heroBook =
                  favoriteBooks.isNotEmpty ? favoriteBooks.first : null;

              return RefreshIndicator(
                color: gold,
                backgroundColor: cardFill,
                onRefresh: () async {
                  await favoritesProvider.refreshFavorites();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      /// TITLE
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Favorites",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: gold,
                            size: 26,
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// HERO CARD
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: borderInactive),
                          boxShadow: [
                            BoxShadow(
                              color: goldGlow.withValues(alpha:0.30),
                              blurRadius: 25,
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              heroBook?.coverUrl.isNotEmpty == true
                                  ? heroBook!.coverUrl
                                  : "assets/books/Book1.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: [
                                bgBottom.withValues(alpha:0.85),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                heroBook?.title ?? "The Midnight Library",
                                style: const TextStyle(
                                  color: textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Your Most Loved Book",
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// FILTERS
                      SizedBox(
                        height: 42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedFilter == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? gold : cardFill,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: borderInactive),
                                ),
                                child: Text(
                                  filters[index],
                                  style: TextStyle(
                                    color: isSelected ? bgTop : textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Favorite Books",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// LOADING
                      if (favoritesProvider.isLoading)
                        const SizedBox(
                          height: 210,
                          child: Center(
                            child: CircularProgressIndicator(color: gold),
                          ),
                        )

                      /// ERROR
                      else if (favoritesProvider.error != null)
                        SizedBox(
                          height: 210,
                          child: Center(
                            child: Text(
                              favoritesProvider.error!,
                              style: const TextStyle(color: gold),
                            ),
                          ),
                        )

                      /// EMPTY
                      else if (favoriteBooks.isEmpty)
                        const SizedBox(
                          height: 210,
                          child: Center(
                            child: Text(
                              'No favorites yet.',
                              style: TextStyle(color: textMuted),
                            ),
                          ),
                        )

                      /// BOOK LIST
                      else
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favoriteBooks.length,
                            itemBuilder: (context, index) {
                              final book = favoriteBooks[index];

                              return FavoriteBookCard(
                                book: book,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookDetailScreen(bookId: book.id),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  favoritesProvider.removeFromFavorites(book.id);
                                },
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 40),

                      const Center(
                        child: Text(
                          "Long press to remove favorite",
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),

      /// FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: gold,
        onPressed: () {
          context.read<FavoritesProvider>().refreshFavorites();
        },
        child: const Icon(Icons.bookmark, color: bgTop),
      ),
    );
  }

  List<BookModel> _applyFilter(List<BookModel> source) {
    if (selectedFilter == 1) {
      return [...source]
        ..sort((a, b) =>
            (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));
    }

    if (selectedFilter == 2) {
      return [...source]
        ..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    }

    if (selectedFilter == 3) {
      return source.where((book) => book.pdfPath.isNotEmpty).toList();
    }

    return source;
  }
}