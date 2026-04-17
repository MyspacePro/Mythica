import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';



class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _showRoleSwitchDialog({
    required BuildContext context,
    required String uid,
    required String currentRole,
  }) async {
    final nextRole = currentRole == 'writer' ? 'reader' : 'writer';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text(
          'Are you sure you want to switch account type?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Switch'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    try {
      await RoleService.instance.switchRole(uid: uid, targetRole: nextRole);
      await context.read<AuthProvider>().refreshSession();
      if (!context.mounted) return;
      await showAppPopup(
        context: context,
        title: 'Role updated',
        message: 'Your account is now switched to $nextRole.',
        buttonText: 'Continue',
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      final message = e.code == 'permission-denied'
          ? 'You are not allowed to switch roles.'
          : e.code == 'network-request-failed'
              ? 'Network error. Please try again.'
              : (e.message ?? 'Failed to switch role');
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final AppUser? user = authProvider.currentUser;
    final bool isGuest = authProvider.isGuest;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<Map<String, dynamic>?>(
      stream: uid == null ? null : RoleService.instance.userProfileStream(uid),
      builder: (context, snapshot) {
        final role = snapshot.data?['role']?.toString() ?? user?.role.name ?? 'reader';
        final isWriterMode = role == 'writer' || role == 'admin';

        final List<Widget> pages = [
          const HomeScreen(),
          WriterAccessGuard(
            child: WriterDashboard(
              currentUser: user,
              isGuest: isGuest,
              isWriterMode: isWriterMode,
            ),
          ),
          const MyLibraryScreen(),
          ProfileScreen(
            isWriterMode: isWriterMode,
            onSwap: () async {
              if (uid == null) return;
              await _showRoleSwitchDialog(
                context: context,
                uid: uid,
                currentRole: role == 'admin' ? 'writer' : role,
              );
            },
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
          ),
        );
      },
    );
  }
}
