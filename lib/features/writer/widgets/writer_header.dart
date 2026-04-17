import 'package:flutter/material.dart';
import 'package:mythica/core/theme/app_colors.dart';

class WriterHeader extends StatelessWidget {
  const WriterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage: AssetImage('assets/profile/writer.png'),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mukesh Patel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Fiction • Motivation',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.lightText,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
