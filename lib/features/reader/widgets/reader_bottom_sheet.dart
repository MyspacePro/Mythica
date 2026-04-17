import 'package:mythica/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReaderBottomSheet extends StatelessWidget {
  const ReaderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReaderProvider>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor ?? Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Font & Theme controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Font size
                IconButton(
                  icon: const Icon(Icons.remove),
                  tooltip: 'Decrease Font Size',
                  onPressed: provider.decreaseFont,
                ),
                Text(
                  'Font: ${provider.fontSize.toInt()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Increase Font Size',
                  onPressed: provider.increaseFont,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Theme selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _themeOption(
                  context,
                  label: 'Light',
                  isSelected: provider.themeMode == ReaderThemeMode.light,
                  onTap: () => provider.changeTheme(ReaderThemeMode.light),
                ),
                _themeOption(
                  context,
                  label: 'Sepia',
                  isSelected: provider.themeMode == ReaderThemeMode.sepia,
                  onTap: () => provider.changeTheme(ReaderThemeMode.sepia),
                ),
                _themeOption(
                  context,
                  label: 'Dark',
                  isSelected: provider.themeMode == ReaderThemeMode.dark,
                  onTap: () => provider.changeTheme(ReaderThemeMode.dark),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bookmarks / Notes / Highlights
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  tooltip: 'Toggle Bookmark',
                  onPressed: () {
                    final page = provider.currentChapter.toString();
                    provider.toggleBookmark(page);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.highlight),
                  tooltip: 'Add Highlight',
                  onPressed: () {
                    // Implement highlight callback or open highlight menu
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.note_add),
                  tooltip: 'Add Note',
                  onPressed: () {
                    // Implement note editor callback
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}