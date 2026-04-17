import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final TextStyle? textStyle;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.height = 6.0,
    this.backgroundColor,
    this.progressColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = backgroundColor ?? theme.dividerColor;
    final fgColor = progressColor ?? theme.colorScheme.primary;
    final style = textStyle ??
        theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold);

    final safeCurrent = currentPage.clamp(1, totalPages);
    final progress = totalPages > 0 ? safeCurrent / totalPages : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: height,
            backgroundColor: bgColor,
            color: fgColor,
          ),
        ),
        const SizedBox(height: 6),
        // Page label
        Text(
          '$safeCurrent / $totalPages',
          style: style,
        ),
      ],
    );
  }
}