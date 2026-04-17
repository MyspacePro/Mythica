import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:mythica/features/auth/screens/reader_genre_selection_screen.dart';
import 'package:mythica/features/auth/screens/writer_genre_selection_screen.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/services/user_service.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  bool _isSaving = false;

  void _selectRole(String role) {
    if (_selectedRole == role) return;
    setState(() => _selectedRole = role);
  }

  Future<void> _continue() async {
    if (_selectedRole == null) {
      _showSnack('Please select a role to continue.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack('Session expired. Please login again.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final authProvider = context.read<AuthProvider>();

      await UserService.instance.updateRole(
        uid: user.uid,
        role: _selectedRole!,
      );

      await authProvider.setUserRole(_selectedRole!);

      if (!mounted) return;

      if (_selectedRole == "reader") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ReaderGenreSelectionScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const WriterGenreSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      _showSnack(_mapError(e));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _mapError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.message ?? 'Authentication error occurred';
    }
    return 'Something went wrong. Please try again.';
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatelessWidget {
  const _RoleSelectionView();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_RoleSelectionScreenState>()!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E1B47),
            Color(0xFF1F1533),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              const Text(
                "Choose Your Experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "How would you like to continue?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB8AFCF),
                ),
              ),

              const SizedBox(height: 60),

              _RoleCard(
                role: "reader",
                title: "Continue as Reader",
                subtitle: "Explore, read and enjoy thousands of books",
                icon: Icons.menu_book,
                isSelected: state._selectedRole == "reader",
                onTap: () => state._selectRole("reader"),
              ),

              const SizedBox(height: 30),

              _RoleCard(
                role: "writer",
                title: "Continue as Writer",
                subtitle: "Create, publish and earn from your stories",
                icon: Icons.edit,
                isSelected: state._selectedRole == "writer",
                onTap: () => state._selectRole("writer"),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD86B),
                    disabledBackgroundColor: const Color(0xFF5C4A80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: state._isSaving ? null : state._continue,
                  child: state._isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1F1533),
                          ),
                        )
                      : const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1533),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String role;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF24163A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFD86B)
                  : const Color(0xFF5C4A80),
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0xFFFFD86B).withValues(alpha:0.35),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFFFFD86B),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB8AFCF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}