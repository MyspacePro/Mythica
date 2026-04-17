import 'dart:ui';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/core/routes/app_routes.dart';
import 'package:mythica/features/book/screen/book_detail_screen.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:mythica/shared/widgets/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/models/user_model.dart';


class WriterDashboard extends StatefulWidget {
  final AppUser? currentUser;
  final bool isGuest;
  final bool isWriterMode;

  const WriterDashboard({
    super.key,
    required this.currentUser,
    required this.isGuest,
    required this.isWriterMode,
  });

  @override
  State<WriterDashboard> createState() => _WriterDashboardState();
}

class _WriterDashboardState extends State<WriterDashboard> {
  int selectedIndex = 0;
  bool _errorShown = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();

      // ✅ Sync user if needed
      if (authProvider.currentUser == null &&
          widget.currentUser != null) {
        // Optional: agar tumhara fetch method hai to use karo
        // await authProvider.fetchUser(widget.currentUser!.uid);
      }

      context.read<WriterProvider>().loadWriterStudio(
            user: widget.currentUser,
            isGuest: widget.isGuest,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
final user = context.select<AuthProvider, AppUser?>(
    (provider) => provider.currentUser,
  );
 final userName =
      user?.name.isNotEmpty == true ? user!.name : "Writer";
    
    
    if (!widget.isWriterMode) {
      return const Scaffold(
        body: Center(
          child: Text('Switch to Writer account from Profile to access this feature'),
        ),
      );
    }

    return Consumer<WriterProvider>(
      builder: (context, writer, _) {
        final error = writer.error;
        if (error != null && !_errorShown) {
          _errorShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            showAppPopup(
              context: context,
              title: 'Something went wrong',
              message: error,
              buttonText: 'OK',
            );
          });
        }

        final books = writer.writerBooks;
        final hasBooks = books.isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1F153B),
                      Color(0xFF261A43),
                      Color(0xFF322254),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: writer.isLoading && !writer.isLoaded
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                                      /// ✅ HEADER WITH REAL USER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Writer Dashboard',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                /// ✅ PROFILE IMAGE
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white24,
                                  backgroundImage: (user?.profileImageUrl
                                                  ?.isNotEmpty ??
                                              false)
                                          ? NetworkImage(
                                              user!.profileImageUrl!)
                                          : null,
                                  child: (user?.profileImageUrl == null ||
                                          user!.profileImageUrl!.isEmpty)
                                      ? const Icon(Icons.person,
                                          color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    icon: Icons.menu_book,
                                    title: 'Total Books',
                                    value: writer.totalBooks.toString(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: StatCard(
                                    icon: Icons.attach_money,
                                    title: 'Earnings',
                                    value: '₹${writer.totalEarnings.toStringAsFixed(0)}',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ActionButton(
                                  icon: Icons.add,
                                  label: 'Create',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.createBook, arguments: const {'source': 'dashboard'});
                                  },
                                ),
                                ActionButton(
                                  icon: Icons.menu_book,
                                  label: 'Manage',
                                  highlighted: true,
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.manageBooks);
                                  },
                                ),
                                ActionButton(
                                  icon: Icons.attach_money,
                                  label: 'Earnings',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.earn);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ActionButton(
                                  icon: Icons.analytics,
                                  label: 'Analytics',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.writerAnalytics);
                                  },
                                ),
                                ActionButton(
                                  icon: Icons.person,
                                  label: 'Profile',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.writerProfile);
                                  },
                                ),
                                ActionButton(
                                  icon: Icons.subscriptions,
                                  label: 'Subscription',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.writerSubscription);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ActionButton(
                                  icon: Icons.publish,
                                  label: 'Publish',
                                  onTap: () {
                                    Navigator.pushNamed(context, AppRoutes.writerPublish);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Recent Books',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (!hasBooks)
                              Container(
                                height: 140,
                                alignment: Alignment.center,
                                child: const Text(
                                  'No books published yet.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            else
                              SizedBox(
                                height: 240,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: books.length,
                                  itemBuilder: (context, index) {
                                    final book = books[index];
                                    final isSelected = index == selectedIndex;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BookDetailScreen(
                                             bookId: book.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: BookCard(
                                        image: book.coverImage,
                                        isSelected: isSelected,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.createBook, arguments: const {'source': 'dashboard'});
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white.withValues(alpha:0.1),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFF7C405),
                                      child: Icon(Icons.add, color: Colors.black),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Create New Book',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFFF7C405)),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                title,
                style: const TextStyle(color: Color(0xFFD3CEDD)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: highlighted ? const Color(0xFFF7C405).withValues(alpha:0.15) : Colors.white.withValues(alpha:0.08),
          boxShadow: highlighted
              ? [
                  BoxShadow(
                    color: const Color(0xFFF7C405).withValues(alpha:0.6),
                    blurRadius: 20,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: highlighted ? const Color(0xFFF7C405) : Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: highlighted ? const Color(0xFFF7C405) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String image;
  final bool isSelected;

  const BookCard({
    super.key,
    required this.image,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSelected ? 170 : 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFE8B503).withValues(alpha:0.6),
                  blurRadius: 25,
                )
              ]
            : [],
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
