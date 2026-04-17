import 'package:mythica/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int booksRead;
  final int saved;
  final int following;
  final void Function(String stat)? onTap;

  const ProfileStats({
    super.key,
    this.booksRead = 0,
    this.saved = 0,
    this.following = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          title: 'Books Read',
          value: booksRead.toString(),
          onTap: () => onTap?.call('books_read'),
        ),
        _StatItem(
          title: 'Saved',
          value: saved.toString(),
          onTap: () => onTap?.call('saved'),
        ),
        _StatItem(
          title: 'Following',
          value: following.toString(),
          onTap: () => onTap?.call('following'),
        ),
      ],
    );
  }
}

class _StatItem extends StatefulWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _StatItem({
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.98 : 1,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: Text(
                      widget.value,
                      key: ValueKey(widget.value),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
