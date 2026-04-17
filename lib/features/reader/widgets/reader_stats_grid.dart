import 'package:mythica/features/reader/controller/reader_controller.dart';
import 'package:mythica/features/reader/widgets/reader_stats_card.dart';
import 'package:flutter/material.dart';

class ReaderStatsGrid extends StatelessWidget {
  final ReaderController controller;
  final VoidCallback? onTap;

  const ReaderStatsGrid({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    // 📱 Responsive grid
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 2 : 4;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,

        // 🔥 Fixed height to avoid overflow
        mainAxisExtent: 90,
      ),
      children: [

        /// 💰 Coins
        ReaderStatsCard(
          title: 'Coins',
          value: controller.readingMinutes.toString(),
          icon: Icons.monetization_on,
          onTap: onTap,
          backgroundColor: const Color(0xFF1A1A1A), // dark grey
        ),

        /// ⚡ XP
        ReaderStatsCard(
          title: 'XP',
          value: controller.progress.toString(),
          icon: Icons.bolt,
          onTap: onTap,
          backgroundColor: const Color(0xFF1A1A1A),
        ),

        /// 🔥 Streak
        ReaderStatsCard(
          title: 'Streak',
          value: '${controller.readingStreak} days',
          icon: Icons.local_fire_department,
          onTap: onTap,
          backgroundColor: const Color(0xFF1A1A1A),
        ),

        /// ✅ Completed
        ReaderStatsCard(
          title: 'Completed',
          value: controller.booksCompleted.toString(),
          icon: Icons.check_circle,
          onTap: onTap,
          backgroundColor: const Color(0xFF1A1A1A),
        ),
      ],
    );
  }
}