import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mythica/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mythica/features/auth/screens/reader_genre_selection_screen.dart';
import 'package:mythica/features/auth/screens/auth_wrapper.dart';

class WriterGenreSelectionScreen extends StatefulWidget {
  const WriterGenreSelectionScreen({Key? key}) : super(key: key);

  @override
  State<WriterGenreSelectionScreen> createState() =>
      _WriterGenreSelectionScreenState();
}

class _WriterGenreSelectionScreenState
    extends State<WriterGenreSelectionScreen> {
  static const List<String> _genres = [
    "Fantasy",
    "Science Fiction",
    "Mystery",
    "Thriller",
    "Romance",
    "Historical Fiction",
    "Short Stories",
    "Poetry",
  ];

  final Set<String> _selectedGenres = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _validateRole();
  }

  Future<void> _validateRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = doc.data()?['role']?.toString();

      if (!mounted) return;

      if (role == 'reader') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ReaderGenreSelectionScreen(),
          ),
        );
      }
    } catch (_) {
      // silent fail (no UI break)
    }
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  Future<void> _continue() async {
    if (_selectedGenres.isEmpty) {
      _showSnack('Please select at least one genre.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack('Session expired. Please login again.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await UserService.instance.completeGenres(
        uid: user.uid,
        genres: _selectedGenres.toList(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    } on FirebaseException catch (e) {
      _showSnack(e.message ?? 'Failed to save genres.');
    } catch (_) {
      _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _skip() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack('Session expired. Please login again.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await UserService.instance.completeGenres(
        uid: user.uid,
        genres: [],
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    } catch (_) {
      _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // 🎨 Colors
  static const Color bgDark = Color(0xFF1F1533);
  static const Color bgTop = Color(0xFF2E1B47);
  static const Color yellow = Color(0xFFFFD86B);
  static const Color chipBorder = Color(0xFF5C4A80);
  static const Color subtitleColor = Color(0xFFB8AFCF);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [bgTop, bgDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Header
                const _Header(),

                const SizedBox(height: 40),

                const Text(
                  "Tell Us What You Love",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Choose your favorite genres to write about.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                /// Genres
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _genres.map((genre) {
                        final isSelected =
                            _selectedGenres.contains(genre);

                        return _GenreChip(
                          genre: genre,
                          isSelected: isSelected,
                          onTap: () => _toggleGenre(genre),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      disabledBackgroundColor: chipBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _continue,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: bgDark,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: bgDark,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Skip
                TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Header Widget
class _Header extends StatelessWidget {
  const _Header();

  static const Color yellow = Color(0xFFFFD86B);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Row(
          children: [
            Icon(Icons.menu_book, color: yellow, size: 26),
            SizedBox(width: 10),
            Text(
              "Writer App",
              style: TextStyle(
                color: white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white24,
        )
      ],
    );
  }
}

/// 🔹 Genre Chip Widget
class _GenreChip extends StatelessWidget {
  final String genre;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  static const Color yellow = Color(0xFFFFD86B);
  static const Color chipBorder = Color(0xFF5C4A80);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? yellow.withValues(alpha:0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? yellow : chipBorder,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: yellow.withValues(alpha:0.4),
                      blurRadius: 15,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                genre,
                style: TextStyle(
                  color: isSelected ? yellow : white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle,
                  color: yellow,
                  size: 18,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}