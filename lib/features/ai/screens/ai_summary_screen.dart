import 'dart:io';

import 'package:mythica/core/monetization/access_rules.dart';
import 'package:flutter/material.dart';
import 'package:mythica/core/monetization/premium_guard.dart';
import 'package:mythica/models/user_model.dart';

class AISummaryScreen extends StatelessWidget {
  final String bookTitle;
  final AppUser? currentUser;
  final bool isGuest;

  const AISummaryScreen({
    super.key,
    required this.bookTitle,
    this.currentUser,
    this.isGuest = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
        title: const Text(
          "AI Summary",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 110, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📚 Book Title
              Text(
                bookTitle,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "AI-powered quick insight",
                style: TextStyle(
                  color: Color(0xFF9F96C8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),

              /// 📖 Summary Block
              PremiumGuard(
                user: currentUser,
                isGuest: isGuest,
                contentType: ContentType.premium,
                lockedView: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF3A2D5C),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFFFFD76A).withValues(alpha:0.30),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Color(0xFFF5C84C),
                            size: 26,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "AI Summary is available for Premium Readers.",
                              style: TextStyle(
                                color: Color(0xFFCFC8E8),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      /// 🟡 Upgrade Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AISummaryScreen(
                                  bookTitle: "Atomic Habits",
                                  currentUser: currentUser,
                                  isGuest: false,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFF5C84C),
                            foregroundColor:
                                const Color(0xFF1F1533),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            overlayColor:
                                MaterialStateProperty.all(
                              const Color(0xFFE6B93E)
                                  .withValues(alpha:0.2),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD76A)
                                      .withValues(alpha:0.30),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Text(
                              "Upgrade",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔓 Premium Unlocked View
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF3A2D5C),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "This AI-generated summary will help readers quickly "
                    "understand the key insights, themes, and core ideas "
                    "of the book in under 3 minutes.",
                    style: TextStyle(
                      color: Color(0xFFCFC8E8),
                      fontSize: 15,
                      height: 1.6,
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