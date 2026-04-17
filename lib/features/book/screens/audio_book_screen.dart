import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioBook {
  final String id;
  final String title;
  final String narrator;
  final String image;
  final double rating;
  final double progress;

  AudioBook({
    required this.id,
    required this.title,
    required this.narrator,
    required this.image,
    required this.rating,
    this.progress = 0,
  });
}

class AudioBookProvider extends ChangeNotifier {
  List<AudioBook> trending = [];
  List<AudioBook> continueListening = [];
  AudioBook? featured;

  bool isLoading = true;

  AudioBookProvider() {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    await Future.delayed(const Duration(milliseconds: 600));

    trending = [
      AudioBook(
        id: "1",
        title: "Dune",
        narrator: "Scott Brick",
        image: "assets/books/Book1.png",
        rating: 4.8,
      ),
      AudioBook(
        id: "2",
        title: "Educated",
        narrator: "Julia Whelan",
        image: "assets/books/Book2.png",
        rating: 4.6,
      ),
      AudioBook(
        id: "3",
        title: "Circe",
        narrator: "Perdita Weeks",
        image: "assets/books/Book3.png",
        rating: 4.7,
      ),
    ];

    continueListening = [
      AudioBook(
        id: "4",
        title: "The Midnight Library",
        narrator: "Carey Mulligan",
        image: "assets/books/Book2.png",
        rating: 4.5,
        progress: 0.6,
      ),
      AudioBook(
        id: "5",
        title: "Atomic Habits",
        narrator: "James Clear",
        image: "assets/books/Book3.png",
        rating: 4.9,
        progress: 0.4,
      ),
    ];

    featured = AudioBook(
      id: "10",
      title: "Project Hail Mary",
      narrator: "Ray Porter",
      image: "assets/books/Book1.png",
      rating: 4.9,
    );

    isLoading = false;
    notifyListeners();
  }

  void playBook(AudioBook book) {
    featured = book;
    notifyListeners();
  }

  List<AudioBook> search(String query) {
    return trending
        .where((b) =>
            b.title.toLowerCase().contains(query.toLowerCase()) ||
            b.narrator.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

class AudioBookDashboard extends StatelessWidget {
  const AudioBookDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioBookProvider(),
      child: const _AudioBookDashboardView(),
    );
  }
}

class _AudioBookDashboardView extends StatefulWidget {
  const _AudioBookDashboardView();

  @override
  State<_AudioBookDashboardView> createState() =>
      _AudioBookDashboardViewState();
}

class _AudioBookDashboardViewState extends State<_AudioBookDashboardView> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioBookProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1F1533),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final trending = searchQuery.isEmpty
        ? provider.trending
        : provider.search(searchQuery);

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
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF251A3F),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF3A2D5C)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    const Text(
                      "Audiobooks",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 24),

                    /// SEARCH
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF251A3F),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF3A2D5C)),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        onChanged: (v) {
                          setState(() => searchQuery = v);
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search,
                              color: Color(0xFFF5C84C)),
                          hintText: "Search audiobooks, narrators...",
                          hintStyle:
                              TextStyle(color: Color(0xFF9F96C8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FEATURED
                    const Text(
                      "Featured Audiobooks 🎧",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 18),

                    _FeaturedCard(provider.featured!),

                    const SizedBox(height: 30),

                    /// CONTINUE LISTENING
                    const Text(
                      "Continue Listening",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: provider.continueListening
                          .map((b) => _ContinueCard(book: b))
                          .toList(),
                    ),

                    const SizedBox(height: 30),

                    /// TRENDING
                    const Text(
                      "Trending Audio",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      height: 165,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trending.length,
                        itemBuilder: (context, index) {
                          final book = trending[index];
                          return _TrendingCard(book: book);
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// MINI PLAYER
                    _MiniPlayer(provider.featured!)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final AudioBook book;

  const _FeaturedCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(book.image, height: 85, width: 85),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<AudioBookProvider>().playBook(book),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF5C84C)),
                  child: const Icon(Icons.play_arrow,
                      color: Color(0xFF1F1533)),
                ),
              )
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text("Narrator: ${book.narrator}",
                    style:
                        const TextStyle(color: Color(0xFF9F96C8))),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5C84C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("⭐ ${book.rating}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1533))),
          )
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final AudioBook book;

  const _ContinueCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(book.image, height: 65),
            ),
            const SizedBox(height: 10),
            Text(book.title,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFFCFC8E8))),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: book.progress,
              backgroundColor: const Color(0xFF3A2D5C),
              valueColor: const AlwaysStoppedAnimation(
                  Color(0xFFF5C84C)),
            )
          ],
        ),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final AudioBook book;

  const _TrendingCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<AudioBookProvider>().playBook(book),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(book.image, height: 120),
            ),
            const SizedBox(height: 8),
            Text(book.title,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFCFC8E8)))
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  final AudioBook book;

  const _MiniPlayer(this.book);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(book.image, height: 50, width: 50),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text("${book.title}\n${book.narrator}",
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFCFC8E8))),
          ),
          const Icon(Icons.play_arrow, color: Color(0xFFF5C84C)),
          const SizedBox(width: 12),
          const Icon(Icons.skip_next, color: Color(0xFFF5C84C)),
        ],
      ),
    );
  }
}