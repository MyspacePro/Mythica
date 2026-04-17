import 'package:flutter/material.dart';
import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/home/mainicon/help_icon/help_support.dart';
import 'package:mythica/features/library/screens/my_library_screen.dart';

import 'edit_profile_screen.dart';
import 'subscription_screen.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu.dart';
import 'widgets/profile_stats.dart';


class ProfileScreen extends StatelessWidget {
  final bool isWriterMode;
  final VoidCallback onSwap;

  const ProfileScreen({
    super.key,
    required this.isWriterMode,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final isWriter = isWriterMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// 🔝 Premium Gradient Header
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1F1533),
                      Color(0xFF2A1E47),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD76A).withValues(alpha:0.25),
                      blurRadius: 30,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const ProfileHeader(),
              ),

              const SizedBox(height: 24),

              /// 📜 Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [

                      /// 📊 Stats Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF251A3F),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: const Color(0xFF3A2D5C),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD76A)
                                  .withValues(alpha:0.12),
                              blurRadius: 25,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: ProfileStats(
                          onTap: (stat) {
                            if (stat == 'books_read' || stat == 'saved') {
                              _pushWithTransition(
                                context,
                                const MyLibraryScreen(),
                              );
                            }

                            if (stat == 'following') {
                              _pushWithTransition(
                                context,
                                const HelpSupportScreen(),
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// ⚙️ Menu Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF251A3F),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: const Color(0xFF3A2D5C),
                          ),
                        ),
                        child: ProfileMenu(
                          onItemTap: (route) =>
                              _handleMenuTap(context, route),
                        ),
                      ),

                      const SizedBox(height: 34),

                      /// 🔄 Swap Mode Button (Premium Gold)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFF5C84C),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            overlayColor: MaterialStateProperty.all(
                                const Color(0xFFE6B93E)),
                          ),
                          onPressed: onSwap,
                          icon: const Icon(
                            Icons.swap_horiz,
                            color: Color(0xFF1F1533),
                          ),
                          label: Text(
                            isWriter
                                ? "Switch to Reader Mode"
                                : "Switch to Writer Mode",
                            style: const TextStyle(
                              color: Color(0xFF1F1533),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// ✏ Floating Edit Button (Premium Gold Glow)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD76A).withValues(alpha:0.3),
              blurRadius: 25,
              spreadRadius: 1,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFF5C84C),
          elevation: 0,
          onPressed: () {
            _pushWithTransition(context, const EditProfileScreen());
          },
          child: const Icon(
            Icons.edit,
            color: Color(0xFF1F1533),
          ),
        ),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String route) {
    switch (route) {
      case 'library':
        _pushWithTransition(context, const MyLibraryScreen());
        break;
      case 'writer_dashboard':
        Navigator.pushNamed(context, AppRoutes.writerDashboard);
        break;
      case 'settings':
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case 'help_support':
        _pushWithTransition(context, const HelpSupportScreen());
        break;
      case 'subscription':
        _pushWithTransition(context, const MySubscriptionScreen());
        break;
      case 'logout':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF251A3F),
            content: Text(
              'Logout flow is not configured yet',
              style: TextStyle(color: Color(0xFFCFC8E8)),
            ),
          ),
        );
        break;
    }
  }

  Future<void> _pushWithTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration:
            const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: page,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}