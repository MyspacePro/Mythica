import 'dart:io';

import 'package:mythica/features/book/screens/book_battle_screen.dart';
import 'package:mythica/features/book/screens/book_detail_screen.dart';
import 'package:mythica/models/user_model.dart';
import 'package:flutter/material.dart';

class AIRecommendationScreen extends StatelessWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const AIRecommendationScreen({
    super.key,
    this.currentUser,
    this.isGuest = true,
  });

  @override
  Widget build(BuildContext context) {
    /// 🔥 Mock AI Recommendation (replace with API later)
    final recommended = dummyBooks.take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text(
          "AI Recommendations",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            const Text(
              "Recommended For You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Based on your reading behavior & interests",
              style: TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 20),

            /// GRID
            Expanded(
              child: recommended.isEmpty
                  ? const Center(
                      child: Text(
                        "No recommendations yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: recommended.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final book = recommended[index];

                        return PremiumGuard(
                          user: currentUser,
                          isGuest: isGuest,
                          contentType: book.isPremium
                              ? ContentType.premium
                              : ContentType.free,

                          /// 🔒 LOCKED VIEW
                          lockedView: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Upgrade to access this premium book",
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                BookCard(book: book),

                                /// LOCK OVERLAY
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ✅ UNLOCKED VIEW
                          child: BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailScreen(
                                    bookId: book.id, // ✅ FIXED
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}