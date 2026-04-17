import 'package:mythica/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CommunityProfileScreen extends StatelessWidget {
  final String name;
  final String role;

  const CommunityProfileScreen({
    super.key,
    required this.name,
    required this.role,
  });

  // 🎨 LUXURY COLOR SYSTEM
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
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
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 28),
                  decoration: const BoxDecoration(
                    color: cardFill,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30)),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildStats(),
                      const SizedBox(height: 28),
                      _buildBio(),
                      const SizedBox(height: 28),
                      _buildButtons(context),
                      const SizedBox(height: 36),
                      _buildSharedImages(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 HEADER
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cardBorder),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cardBorder),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withValues(alpha:0.15),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: cardFill,
            child: Icon(
              Icons.person,
              size: 60,
              color: goldPrimary,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          role,
          style: const TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  // 🔹 STATS
  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bgPrimary.withValues(alpha:0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem("120", "Friends"),
          _VerticalDivider(),
          _StatItem("8", "Groups"),
          _VerticalDivider(),
          _StatItem("24", "Books"),
        ],
      ),
    );
  }

  // 🔹 BIO
  Widget _buildBio() {
    return const Text(
      "Passionate reader who loves fantasy and self-growth books. "
      "Always open for book discussions and new recommendations!",
      style: TextStyle(
        fontSize: 14,
        height: 1.6,
        color: textMuted,
      ),
    );
  }

  // 🔹 BUTTONS
  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldPrimary,
              foregroundColor: bgPrimary,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: goldGlow.withValues(alpha:0.3),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend request sent')),
              );
            },
            child: const Text(
              "Add Friend",
              style:
                  TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: cardBorder),
              backgroundColor: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.chat,
                arguments: {'title': name, 'isPrivateChat': true},
              );
            },
            child: const Text(
              "Message",
              style: TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 SHARED PHOTOS
  Widget _buildSharedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shared Photos",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: bgPrimary.withValues(alpha:0.5),
                borderRadius:
                    BorderRadius.circular(18),
                border:
                    Border.all(color: cardBorder),
              ),
              child: const Icon(
                Icons.image,
                color: goldPrimary,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem(this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 2),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Color(0xFF3A2D5C),
    );
  }
}