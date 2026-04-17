import 'package:mythica/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReaderBottomBar extends StatelessWidget {
  const ReaderBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReaderProvider>();
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor.withValues(alpha:0.85),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      height: 60,
      child: Row(
        children: [
          // Previous chapter button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: theme.iconTheme.color,
            tooltip: 'Previous Chapter',
            onPressed: provider.previousChapter,
          ),

          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
              
                minHeight: 6,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.secondary,
                ),
              ),
            ),
          ),

          // Next chapter button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: theme.iconTheme.color,
            tooltip: 'Next Chapter',
            onPressed: provider.nextChapter,
          ),
        ],
      ),
    );
  }
}