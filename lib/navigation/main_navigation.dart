import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final AppUser? user = auth.currentUser;
    final bool isGuest = auth.isGuest;

    final bool isWriter =
        !isGuest && user != null && user.role == UserRole.writer;

    /// Pages based on role
    final List<Widget> pages = [
      const HomeScreen(),
      if (isWriter)
        WriterDashboard(
          currentUser: user,
          isGuest: isGuest, isWriterMode: isWriter,
        ),
      const LibraryScreen(),
      ProfileScreen(isWriterMode: isWriter, onSwap: () {  },),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha:0.95),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              /// HOME
              _buildNavItem(Icons.home, "Home", 0),

              /// WRITER (Only for writers)
              if (isWriter)
                _buildNavItem(Icons.edit, "Writer", 1),

              /// LIBRARY
              _buildNavItem(
                Icons.library_books,
                "Library",
                isWriter ? 2 : 1,
              ),

              /// PROFILE
              _buildNavItem(
                Icons.person,
                "Profile",
                isWriter ? 3 : 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDark.withValues(alpha:0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.white
                    : AppColors.premiumYellow,
                size: 24,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
