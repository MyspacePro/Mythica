import 'package:mythica/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final void Function(String route)? onItemTap;

  const ProfileMenu({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.library_books,
          title: 'My Library',
          onTap: () => onItemTap?.call('library'),
        ),
        _MenuItem(
          icon: Icons.edit,
          title: 'Writer Dashboard',
          onTap: () => onItemTap?.call('writer_dashboard'),
        ),
        _MenuItem(
          icon: Icons.workspace_premium,
          title: 'My Subscription',
          onTap: () => onItemTap?.call('subscription'),
        ),
        _MenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => onItemTap?.call('settings'),
        ),
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => onItemTap?.call('help_support'),
        ),
        _MenuItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () => onItemTap?.call('logout'),
        ),
      ],
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _pressed ? 0.98 : 1,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
