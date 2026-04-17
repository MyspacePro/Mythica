import 'package:flutter/material.dart';

class HighlightMenu extends StatelessWidget {
  final VoidCallback onHighlight;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback? onBookmark;
  final bool isBookmarked;

  const HighlightMenu({
    super.key,
    required this.onHighlight,
    required this.onCopy,
    required this.onShare,
    this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _MenuItem(
              icon: Icons.highlight,
              label: 'Highlight',
              onTap: onHighlight,
            ),
            _MenuItem(
              icon: Icons.copy,
              label: 'Copy',
              onTap: onCopy,
            ),
            _MenuItem(
              icon: Icons.share,
              label: 'Share',
              onTap: onShare,
            ),
            if (onBookmark != null)
              _MenuItem(
                icon: isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                label: isBookmarked ? 'Saved' : 'Save',
                onTap: onBookmark!,
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}