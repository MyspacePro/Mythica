import 'package:book_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class ServiceTile extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;

  const ServiceTile({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.secondaryDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.cardDark,
                  width: 1.4,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.premiumYellow,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}