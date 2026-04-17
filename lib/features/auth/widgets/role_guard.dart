import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mythica/config/app_config.dart';
import 'package:mythica/features/home/screens/home_screen.dart';
import 'package:mythica/models/user_model.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/services/role_service.dart';
import 'package:mythica/shared/widgets/app_popup.dart';

class WriterAccessGuard extends StatefulWidget {
  const WriterAccessGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WriterAccessGuard> createState() => _WriterAccessGuardState();
}

class _WriterAccessGuardState extends State<WriterAccessGuard> {
  bool _redirected = false;
  late Future<bool> _accessFuture;

  @override
  void initState() {
    super.initState();
    _accessFuture = _canAccessWriterFeatures();
  }

  Future<bool> _canAccessWriterFeatures() async {
    if (isDummyMode) {
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) return false;
      return user.role == UserRole.writer || user.role == UserRole.admin;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final role = await RoleService.instance.fetchRole(uid);
    return RoleService.instance.isWriterOrAdmin(role);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _accessFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data != true) {
          if (!_redirected) {
            _redirected = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              showAppPopup(
                context: context,
                title: 'Access denied',
                message: 'Switch to Writer account from Profile to access this feature',
                buttonText: 'OK',
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            });
          }

          return const Scaffold(
            body: SizedBox.shrink(),
          );
        }

        return widget.child;
      },
    );
  }
}
