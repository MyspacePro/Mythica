import 'dart:ui';
import 'package:mythica/features/home/mainicon/setting_icon/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mythica/features/profile/profile_screen.dart' show ProfileScreen;
import 'package:mythica/features/subscription/reader_subscription_screen.dart' show ReaderSubscriptionScreen;
import 'package:mythica/features/profile/edit_profile_screen.dart';
import 'package:mythica/features/library/screens/my_library_screen.dart';
import 'package:mythica/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  /// 🎨 Colors
  static const Color bgTop = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgBottom = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  /// 🔥 Animated Navigation
  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        final slide = Tween<Offset>(
          begin: const Offset(0.1, 0),
          end: Offset.zero,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  /// 🔥 Navigate helper
  void _go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, _animatedRoute(page));
  }

  /// 🔥 Get user initials
  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "U";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = user?.displayName ?? "User";
    final email = user?.email ?? "";
    final initials = _getInitials(name);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [bgTop, bgMid, bgBottom],
            ),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withValues(alpha:0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: bgTop.withValues(alpha:0.95),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    /// PROFILE
                    _buildProfileHeader(initials, name, email),

                    const SizedBox(height: 28),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 20),
                        children: [
                          _menuItem(
                            context,
                            icon: Icons.person_outline,
                            title: "My Account",
                            onTap: () => _go(
                              context,
                              ProfileScreen(
                                isWriterMode: false,
                                onSwap: () {},
                              ),
                            ),
                          ),
                          _menuItem(
                            context,
                            icon: Icons.edit_outlined,
                            title: "Edit Profile",
                            onTap: () => _go(context, const EditProfileScreen()),
                          ),
                          _menuItem(
                            context,
                            icon: Icons.subscriptions_outlined,
                            title: "My Subscription",
                            onTap: () =>
                                _go(context, const ReaderSubscriptionScreen()),
                          ),
                          _menuItem(
                            context,
                            icon: Icons.library_books_outlined,
                            title: "My Library",
                            onTap: () =>
                                _go(context, const MyLibraryScreen()),
                          ),
                          _menuItem(
                            context,
                            icon: Icons.settings_outlined,
                            title: "Settings",
                            onTap: () =>
                                _go(context, const SettingsScreen()),
                          ),

                          const SizedBox(height: 20),

                          _menuItem(
                            context,
                            icon: Icons.logout,
                            title: "Logout",
                            isLogout: true,
                            onTap: () {
                              Navigator.pop(context);
                              _showLogoutDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String initials, String name, String email) {
    return Column(
      children: [
        Container(
          height: 92,
          width: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardFill,
            border: Border.all(color: borderInactive),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withValues(alpha:0.3),
                blurRadius: 18,
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 30,
                color: gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          name,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          email,
          style: const TextStyle(
            color: textMuted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderInactive),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? goldDark : gold,
              ),
              const SizedBox(width: 18),
              Text(
                title,
                style: TextStyle(
                  color: isLogout ? goldDark : textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 LOGOUT
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text("Logout", style: TextStyle(color: textPrimary)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: gold)),
          ),
        ],
      ),
    );
  }
}