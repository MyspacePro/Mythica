import 'package:flutter/material.dart';

class ReaderAnalyticsWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color? iconColor;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const ReaderAnalyticsWidget({
    super.key,
    this.onTap,
    this.text = 'View detailed reading analytics',
    this.icon = Icons.analytics,
    this.iconColor,
    this.textStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final iconClr = iconColor ?? theme.colorScheme.primary;
    final style = textStyle ??
        theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconClr),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: style,
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.iconTheme.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}