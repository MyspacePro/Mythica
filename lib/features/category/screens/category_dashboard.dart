import 'package:flutter/material.dart';

class CategoryDashboard extends StatelessWidget {
  const CategoryDashboard({Key? key}) : super(key: key);

  void onCategoryClick(BuildContext context, CategoryModel category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${category.title} clicked")),
    );
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
              Color(0xFF140F26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                /// APP TITLE
                const Text(
                  "BookVerse",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9F96C8),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Explore Categories 📚",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Find books that match the mood.",
                  style: TextStyle(
                    color: Color(0xFFCFC8E8),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                /// SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFFCFC8E8)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Search genres, authors, books...",
                          style: TextStyle(
                            color: Color(0xFF9F96C8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.tune, color: Color(0xFFF5C84C)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// CATEGORY GRID
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dummyCategories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 1.15,
                          ),
                          itemBuilder: (context, index) {
                            final category = dummyCategories[index];

                            return CategoryCard(
                              category: category,
                              onTap: () =>
                                  onCategoryClick(context, category),
                            );
                          },
                        ),

                        const SizedBox(height: 34),

                        /// TRENDING
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Trending Categories 🔥",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 125,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trendingBooks.length,
                            itemBuilder: (context, index) {
                              return TrendingCard(
                                image: trendingBooks[index],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 34),

                        /// RECOMMENDED
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recommended For You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Based on your reading",
                            style: TextStyle(
                              color: Color(0xFF9F96C8),
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: const Color(0xFF251A3F),
        selectedItemColor: const Color(0xFFF5C84C),
        unselectedItemColor: const Color(0xFFCFC8E8),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Discover"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Browse"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: "Community"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

/// CATEGORY MODEL
class CategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/// CATEGORY CARD
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1533),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFFF5C84C),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF9F96C8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFCFC8E8),
            )
          ],
        ),
      ),
    );
  }
}

/// TRENDING CARD
class TrendingCard extends StatelessWidget {
  final String image;

  const TrendingCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// DUMMY DATA
final List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: "fiction",
    title: "Fiction",
    subtitle: "24k books",
    icon: Icons.menu_book,
  ),
  CategoryModel(
    id: "self",
    title: "Self Growth",
    subtitle: "2.3k books",
    icon: Icons.trending_up,
  ),
  CategoryModel(
    id: "comics",
    title: "Comics",
    subtitle: "1.3k books",
    icon: Icons.auto_stories,
  ),
  CategoryModel(
    id: "romance",
    title: "Romance",
    subtitle: "3.1k books",
    icon: Icons.favorite,
  ),
];

/// TRENDING IMAGES
final List<String> trendingBooks = [
  "assets/books/Book1.png",
  "assets/books/Book2.png",
  "assets/books/Book3.png",
  "assets/books/Book4.png",
];