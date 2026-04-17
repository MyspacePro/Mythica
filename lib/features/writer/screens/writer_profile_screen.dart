import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WriterProfileScreen extends StatelessWidget {
  const WriterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _ProfileHeader(),
              SizedBox(height: 80),
              _StatsSection(),
              SizedBox(height: 36),
              _SectionTitle("Published Books"),
              SizedBox(height: 20),
              _BooksGrid(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PROFILE HEADER
////////////////////////////////////////////////////////////

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  String _initialsFromName(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
final user = authProvider.currentUser;
    final displayName =
        (user?.name.trim().isNotEmpty ?? false) ? user!.name.trim() : 'User';

    final initials = _initialsFromName(displayName);

    final userDetails = [
      if (user?.email.trim().isNotEmpty ?? false) user!.email.trim(),
      // Agar future me add kare: phone, city etc
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 230,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1F1533),
                Color(0xFF2A1E47),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
        ),
        Positioned(
          bottom: -65,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF5C84C),
                    width: 3,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4DFFD76A),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xFF251A3F),

                  /// ✅ REAL PROFILE IMAGE
                 backgroundImage: user?.profileImageUrl != null &&
        user!.profileImageUrl!.isNotEmpty
    ? NetworkImage(user.profileImageUrl!)
    : null,

child: (user?.profileImageUrl == null ||
        user!.profileImageUrl!.isEmpty)
                      ? Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5C84C),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              /// ✅ REAL NAME
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    color: Color(0xFFF5C84C),
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// ✅ USER DETAILS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  userDetails.isEmpty
                      ? 'No profile details available.'
                      : userDetails.join(' • '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCFC8E8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// BUTTON (future use)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5C84C),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4DFFD76A),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Follow",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1533),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// STATS SECTION
////////////////////////////////////////////////////////////

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _StatItem(value: "12", label: "Books"),
          _StatItem(value: "1.2K", label: "Subscribers"),
          _StatItem(value: "4.8", label: "Rating"),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5C84C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// BOOKS GRID
////////////////////////////////////////////////////////////

class _BooksGrid extends StatelessWidget {
  const _BooksGrid();

  @override
  Widget build(BuildContext context) {
    final books = [
      "Dark Mind",
      "Silent Love",
      "Startup Fire",
      "Broken Dreams",
      "The Last Call",
      "Hidden Truth",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 125,
                decoration: BoxDecoration(
                  color: const Color(0xFF251A3F),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF3A2D5C)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFFF5C84C),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                books[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION TITLE
////////////////////////////////////////////////////////////

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}