import 'package:flutter/material.dart';

class ReaderStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const ReaderStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
    this.backgroundColor = const Color(0xFF1A1A1A),
  });

   @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        // 🔥 CARD COLOR
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2E2E2E),
          ),
        ),

        child: Row(
          children: [

            /// Icon
            Icon(
              icon,
              color: const Color(0xFFF5C84C),
              size: 22,
            ),

            const SizedBox(width: 10),

            /// Texts
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}