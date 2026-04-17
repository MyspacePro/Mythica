import 'package:flutter/material.dart';

class ReadingTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final int rewardCoins;
  final double progress; // 0.0 → 1.0
  final bool isCompleted;
  final VoidCallback? onTap;

  const ReadingTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.rewardCoins,
    required this.progress,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Title + Reward
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                /// 🪙 Reward Coins
                Row(
                  children: [
                    const Icon(Icons.monetization_on,
                        size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      "$rewardCoins",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 Description
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color:
                    isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: isCompleted ? 1 : progress,
                minHeight: 8,
                backgroundColor:
                    isDark ? Colors.grey[800] : Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 Bottom Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCompleted
                      ? "Completed"
                      : "${(progress * 100).toInt()}% completed",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? Colors.green
                        : isDark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                  ),
                ),

                if (!isCompleted)
                  Text(
                    "Tap to Continue",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}