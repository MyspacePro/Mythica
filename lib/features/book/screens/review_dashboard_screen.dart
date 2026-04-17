
import 'package:mythica/features/home/mainicon/reviews_icon/models/review_model.dart';
import 'package:mythica/features/home/mainicon/reviews_icon/provider/review_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewDashboardScreen extends StatelessWidget {
  const ReviewDashboardScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.ensureFetched(bookId);
        });

        return Scaffold(
          backgroundColor: const Color(0xFF1F1533),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD76A).withValues(alpha:0.3),
                  blurRadius: 18,
                  spreadRadius: 1,
                )
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFF5C84C),
              onPressed: () {},
              child: const Icon(Icons.mic, color: Color(0xFF1F1533)),
            ),
          ),
          bottomNavigationBar: _bottomNav(),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1F1533),
                  Color(0xFF2A1E47),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerCard(),
                      const SizedBox(height: 28),
                      const Text(
                        'Overall Rating',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            provider.overallRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Color(0xFFF5C84C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${provider.totalReviews} Reviews',
                            style: const TextStyle(color: Color(0xFF9F96C8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Rating Breakdown',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        children: List.generate(
                          5,
                          (index) {
                            final star = 5 - index;
                            return _ratingBar(
                              star,
                              provider.ratingBreakdown[star] ?? 0.0,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      _writeReviewCard(context, provider),
                      const SizedBox(height: 16),
                      if (provider.isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              color: Color(0xFFF5C84C),
                            ),
                          ),
                        ),
                      if (provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      const Text(
                        'User Reviews',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!provider.isLoading && provider.reviews.isEmpty)
                        const Text(
                          'No Reviews Yet',
                          style: TextStyle(color: Color(0xFFCFC8E8)),
                        )
                      else
                        Column(
                          children: List.generate(
                            provider.reviews.length,
                            (index) => _reviewCard(
                              provider.reviews[index],
                              () => provider.toggleLike(
                                bookId,
                                provider.reviews[index].id,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A1E47), Color(0xFF140F26)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Hail Mary',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text('Andy Weir', style: TextStyle(color: Color(0xFFCFC8E8))),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Color(0xFFF5C84C)),
        ],
      ),
    );
  }

  Widget _writeReviewCard(BuildContext context, ReviewProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Write Your Review',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () => provider.setSelectedStars(index + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.star,
                    color: index < provider.selectedStars
                        ? const Color(0xFFF5C84C)
                        : const Color(0xFF3A2D5C),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: provider.reviewController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
              filled: true,
              fillColor: const Color(0xFF1F1533),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFF3A2D5C)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFF3A2D5C)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD76A).withValues(alpha:0.3),
                  blurRadius: 20,
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5C84C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      await provider.submitReview(
                        bookId,
                        provider.selectedStars,
                        provider.reviewController.text,
                      );

                      if (context.mounted && provider.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFF251A3F),
                            content: Text(
                              'Review Submitted',
                              style: TextStyle(color: Color(0xFFF5C84C)),
                            ),
                          ),
                        );
                      }
                    },
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Color(0xFF1F1533),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _reviewCard(ReviewModel review, VoidCallback onLike) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    final isLiked = userId != null && review.likedBy.contains(userId);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onLike,
                child: Text(
                  isLiked ? 'Liked' : 'Like',
                  style: const TextStyle(color: Color(0xFFF5C84C)),
                ),
              )
            ],
          ),
          Row(
            children: List.generate(
              review.rating.clamp(1, 5).toInt(),
              (i) => const Icon(
                Icons.star,
                color: Color(0xFFF5C84C),
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(review.review, style: const TextStyle(color: Color(0xFFCFC8E8))),
          const SizedBox(height: 8),
          Text(
            '👍 ${review.likes} likes',
            style: const TextStyle(color: Color(0xFF9F96C8)),
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text('$star', style: const TextStyle(color: Color(0xFFCFC8E8))),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A2D5C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percent,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF5C84C), Color(0xFFE6B93E)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(color: Color(0xFF9F96C8)),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF251A3F),
      selectedItemColor: Color(0xFFF5C84C),
      unselectedItemColor: Color(0xFF9F96C8),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
