import 'package:flutter/material.dart';

class FontSettingsPanel extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final double minFontSize;
  final double maxFontSize;
  final Color? iconColor;
  final double step;

  const FontSettingsPanel({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
    this.minFontSize = 12,
    this.maxFontSize = 32,
    this.iconColor,
    this.step = 2,
  });

  void _increaseFont() {
    final newSize = (fontSize + step).clamp(minFontSize, maxFontSize);
    if (newSize != fontSize) {
      onFontSizeChanged(newSize);
    }
  }

  void _decreaseFont() {
    final newSize = (fontSize - step).clamp(minFontSize, maxFontSize);
    if (newSize != fontSize) {
      onFontSizeChanged(newSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color color =
        iconColor ?? theme.colorScheme.primary;

    final isMin = fontSize <= minFontSize;
    final isMax = fontSize >= maxFontSize;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DECREASE
            _IconBtn(
              icon: Icons.remove,
              color: color,
              onTap: isMin ? null : _decreaseFont,
              tooltip: 'Decrease font size',
            ),

            const SizedBox(width: 6),

            /// FONT VALUE
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 40),
              child: Center(
                child: Text(
                  fontSize.toStringAsFixed(0),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            /// INCREASE
            _IconBtn(
              icon: Icons.add,
              color: color,
              onTap: isMax ? null : _increaseFont,
              tooltip: 'Increase font size',
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String tooltip;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 22,
              color: onTap == null
                  ? color.withValues(alpha:0.4)
                  : color,
            ),
          ),
        ),
      ),
    );
  }
}