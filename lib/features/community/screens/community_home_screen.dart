import 'package:mythica/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  TextEditingController searchController = TextEditingController();

  final List<String> tabs = ["Readers", "Writers", "Common"];

  // 🎨 Luxury Color System
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      floatingActionButton: _buildDiscussionButton(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgPrimary,
              bgSecondary,
              bgDeep,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 28),
              _buildSegmentedTabs(),
              const SizedBox(height: 22),
              _buildSearchBar(),
              const SizedBox(height: 28),
              Expanded(child: _buildMainCard()),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Community",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cardBorder),
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/user.jpg"),
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: goldPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: goldGlow.withValues(alpha:0.6),
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// SEGMENTED TABS
  Widget _buildSegmentedTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          bool isSelected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isSelected ? goldPrimary : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: goldGlow.withValues(alpha:0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? bgPrimary : textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: cardFill,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: cardBorder),
        ),
        child: TextField(
          controller: searchController,
          style: const TextStyle(color: textPrimary),
          decoration: const InputDecoration(
            hintText: "Search members or groups...",
            hintStyle: TextStyle(color: textMuted),
            prefixIcon: Icon(Icons.search, color: textSecondary),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }

  /// MAIN CONTENT
  Widget _buildMainCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            "Readers Active Members",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _memberCard("Alexia R", "Fantasy Lover", true),
          _memberCard("Rohan Mehta", "Sci-Fi Enthusiast", true),
          const SizedBox(height: 32),
          const Text(
            "Readers Groups",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _joinGroupCard("Epic Sci-Fi Reads", "120 members"),
          const SizedBox(height: 110),
        ],
      ),
    );
  }

  /// MEMBER CARD
  Widget _memberCard(String name, String subtitle, bool online) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {'title': name, 'isPrivateChat': true},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardFill,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: textMuted)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: textSecondary)
          ],
        ),
      ),
    );
  }

  /// JOIN GROUP CARD
  Widget _joinGroupCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: goldPrimary,
            child: Icon(Icons.menu_book, color: bgPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: textMuted)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.chat,
                arguments: {'title': title, 'isPrivateChat': false},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: goldPrimary,
              foregroundColor: bgPrimary,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: goldGlow.withValues(alpha:0.3),
            ),
            child: const Text("Join"),
          )
        ],
      ),
    );
  }

  /// FLOATING BUTTON
  Widget _buildDiscussionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {'title': 'Community Discussion', 'isPrivateChat': false},
        );
      },
      backgroundColor: goldPrimary,
      elevation: 0,
      icon: const Icon(Icons.chat_bubble, color: bgPrimary),
      label: const Text(
        "Start Discussion",
        style: TextStyle(
            color: bgPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }
}