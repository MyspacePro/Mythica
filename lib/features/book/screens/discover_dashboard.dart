import 'package:mythica/models/writer_book_model.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/features/home/mainicon/discover_icon/provider/discover_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverDashboard extends StatefulWidget {
  const DiscoverDashboard({super.key});

  @override
  State<DiscoverDashboard> createState() => _DiscoverDashboardState();
}

class _DiscoverDashboardState extends State<DiscoverDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DiscoverProvider>().loadDiscoverData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, discover, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF1F1533),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1F1533),
                  Color(0xFF2A1E47),
                  Color(0xFF140F26),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: discover.refreshData,
                color: const Color(0xFFF5C84C),
                backgroundColor: const Color(0xFF251A3F),
                child: _buildBody(discover),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(DiscoverProvider discover) {
    if (discover.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFF5C84C),
        ),
      );
    }

    if (discover.error != null) {
      return _ErrorState(message: discover.error!);
    }

    if (discover.visibleBooks.isEmpty) {
      return const _EmptyState();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          const Text(
            "Discover",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          _buildSearchBar(discover),

          const SizedBox(height: 24),

          _buildGenreChips(discover),

          const SizedBox(height: 32),

          _buildHorizontalSection(
            title: "Trending Now 🔥",
            books: discover.trendingBooks,
          ),

          const SizedBox(height: 32),

          _buildGridSection(
            title: "Popular Books",
            books: discover.popularBooks.take(4).toList(),
          ),

          const SizedBox(height: 32),

          _buildHorizontalSection(
            title: "New Arrivals",
            books: discover.newArrivalsBooks,
          ),

          const SizedBox(height: 32),

          _buildGridSection(
            title: "Top Rated",
            books: discover.topRatedBooks.take(4).toList(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar(DiscoverProvider discover) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: discover.searchBooks,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFFCFC8E8)),
          hintText: "Search books, authors...",
          hintStyle: TextStyle(color: Color(0xFF9F96C8)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGenreChips(DiscoverProvider discover) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: discover.genres.map((genre) {
          final selected = discover.selectedGenre == genre;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(genre),
              selected: selected,
              onSelected: (_) => discover.filterByGenre(genre),
              selectedColor: const Color(0xFFF5C84C),
              backgroundColor: const Color(0xFF251A3F),
              labelStyle: TextStyle(
                color: selected ? const Color(0xFF1F1533) : Colors.white70,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalSection({
    required String title,
    required List<Book> books,
  }) {
    if (books.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return _BookCard(
                book: books[index],
                onTap: () => _handleBookTap(context, books[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection({
    required String title,
    required List<Book> books,
  }) {
    if (books.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return _BookCard(
              book: books[index],
              onTap: () => _handleBookTap(context, books[index]),
            );
          },
        ),
      ],
    );
  }

  void _handleBookTap(BuildContext context, Book book) {
    final auth = context.read<AuthProvider>();
    final isPremiumUser = auth.currentUser?.isPremium ?? false;

    if (book.isPaid && !isPremiumUser) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Premium Required'),
          content: Text('Upgrade to Premium to access this book'),
        ),
      );
      return;
    }

  
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const _BookCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.asset(
                book.coverImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (book.isPaid)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C84C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Premium',
                      style: TextStyle(
                        color: Color(0xFF1F1533),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No books available right now.",
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}