import 'package:flutter/material.dart';

class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry padding;

  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onTap,
    this.size = 26,
    this.activeColor,
    this.inactiveColor,
    this.padding = const EdgeInsets.all(6),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color active = activeColor ?? theme.colorScheme.primary;
    final Color inactive =
        inactiveColor ?? theme.iconTheme.color ?? Colors.grey;

    return Semantics(
      button: true,
      label: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size),
          child: Padding(
            padding: padding,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                key: ValueKey<bool>(isBookmarked),
                color: isBookmarked ? active : inactive,
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}