import 'package:flutter/material.dart';

class ReadingRoomScreen extends StatelessWidget {
  final String groupName;

  const ReadingRoomScreen({super.key, required this.groupName});

  // 🎨 LUXURY COLOR SYSTEM
  static const Color primaryBg = Color(0xFF1F1533);
  static const Color gradientMid = Color(0xFF2A1E47);
  static const Color deepDark = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBg,
              gradientMid,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: primaryBg,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView(
                    children: [
                      _buildCurrentBookCard(),
                      const SizedBox(height: 32),
                      _buildProgressSection(),
                      const SizedBox(height: 32),
                      _buildMembersProgress(),
                      const SizedBox(height: 40),
                      _buildActions(),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                color: goldPrimary, size: 26),
          ),
          const SizedBox(width: 16),
          Text(
            groupName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimary,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBookCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderInactive),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 95,
            width: 65,
            decoration: BoxDecoration(
              color: goldPrimary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: goldGlow.withValues(alpha:0.3),
                  blurRadius: 16,
                )
              ],
            ),
            child: const Icon(Icons.menu_book,
                color: primaryBg, size: 32),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Atomic Habits",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "James Clear",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Group Progress",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: LinearProgressIndicator(
            value: 0.6,
            minHeight: 12,
            backgroundColor: borderInactive,
            valueColor:
                const AlwaysStoppedAnimation(goldPrimary),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "60% Completed",
          style: TextStyle(
            color: textMuted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersProgress() {
    final members = [
      {"name": "Aman", "progress": 0.8},
      {"name": "Riya", "progress": 0.6},
      {"name": "Karan", "progress": 0.5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Members Progress",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        ...members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member["name"] as String,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: LinearProgressIndicator(
                    value: member["progress"] as double,
                    minHeight: 10,
                    backgroundColor: borderInactive,
                    valueColor:
                        const AlwaysStoppedAnimation(goldPrimary),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withValues(alpha:0.3),
                blurRadius: 20,
              )
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldPrimary,
              padding:
                  const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Start Reading Together",
              style: TextStyle(
                color: primaryBg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: cardFill,
              side: const BorderSide(
                  color: borderInactive),
              padding:
                  const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Schedule Session",
              style: TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }
}