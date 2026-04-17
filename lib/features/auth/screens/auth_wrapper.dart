import 'package:mythica/features/admin/admin_dashboard.dart';
import 'package:mythica/features/auth/screens/genre_selection_screen.dart';
import 'package:mythica/features/auth/screens/login_screen.dart';
import 'package:mythica/features/auth/screens/splash_screen.dart';
import 'package:mythica/features/home/home_screen.dart';
import 'package:mythica/services/auth_service.dart';
import 'package:mythica/services/role_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// DESTINATION ENUM (SAFE NAVIGATION CONTROL)
enum _AuthDestination {
  login,
  admin,
  roleSelection,
  home,
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  /// 🔍 DETERMINE FINAL ROUTE
  _AuthDestination _resolveRoute(Map<String, dynamic>? profile) {
    if (profile == null) return _AuthDestination.roleSelection;

    final role = profile['role']?.toString();
    final isProfileCompleted = profile['profileCompleted'] == true;

    debugPrint("👤 Role: $role | Completed: $isProfileCompleted");

    switch (role) {
      case 'admin':
        return _AuthDestination.admin;

      case 'reader':
      case 'writer':
        return isProfileCompleted
            ? _AuthDestination.home
            : _AuthDestination.roleSelection;

      default:
        return _AuthDestination.roleSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        /// ⏳ AUTH LOADING
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        /// ❌ AUTH ERROR
        if (authSnapshot.hasError) {
          debugPrint("🔥 Auth Error: ${authSnapshot.error}");
          return const LoginScreen();
        }

        final user = authSnapshot.data;

        /// 🚫 NOT LOGGED IN
        if (user == null) {
          return const LoginScreen();
        }

        /// ✅ LOGGED IN → FETCH PROFILE
        return StreamBuilder<Map<String, dynamic>?>(
          stream: RoleService.instance.userProfileStream(user.uid),
          builder: (context, profileSnapshot) {
            /// ⏳ PROFILE LOADING
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            /// ❌ FIRESTORE ERROR
            if (profileSnapshot.hasError) {
              debugPrint("🔥 Firestore Error: ${profileSnapshot.error}");
              return const HomeScreen(); // fallback safe
            }

            final profile = profileSnapshot.data;

            /// 🆕 FIRST TIME USER
            if (profile == null) {
              debugPrint("🆕 New User → Role Selection");
              return const RoleSelectionScreen();
            }

            /// 🎯 FINAL DESTINATION
            final destination = _resolveRoute(profile);

            switch (destination) {
              case _AuthDestination.admin:
                return const AdminDashboard();

              case _AuthDestination.roleSelection:
                return const RoleSelectionScreen();

              case _AuthDestination.home:
                return const HomeScreen();

              case _AuthDestination.login:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}