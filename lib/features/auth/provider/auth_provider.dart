import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mythica/models/user_model.dart';
import 'package:mythica/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AppUser? _user;
  bool _isLoading = false;
  bool _isGuest = true;
  String? _error;
  String? _selectedUserRole;
  bool _requiresProfileCompletion = false;
  bool _isAdmin = false;

  /// ================= GETTERS =================

  AppUser? get currentUser => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _user != null && !_isGuest;
  String? get error => _error;
  String? get selectedUserRole => _selectedUserRole;
  bool get needsOnboarding => !(_user?.hasCompletedOnboarding ?? false);
  bool get requiresProfileCompletion => _requiresProfileCompletion;
  bool get isAdmin => _isAdmin;

  /// ================= INIT =================

  Future<void> initialize() async {
    _setLoading(true);

    try {
      final user = await _authService.getCurrentUser();
      _user = user;
      _isGuest = user == null;

      if (user != null) {
        await _loadUserMeta(user.uid);
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// ================= COMMON USER META =================

  Future<void> _loadUserMeta(String uid) async {
    final doc = await _authService.getUserDocument(uid);

    _isAdmin = doc?['role'] == 'admin';
    _requiresProfileCompletion =
        !(await _authService.isProfileCompleted(uid));
  }

  /// ================= ROLE =================

  Future<void> setUserRole(String role) async {
    if (_user == null) return;

    _setLoading(true);

    try {
      await _authService.setUserRole(
        uid: _user!.uid,
        role: role,
      );

      _selectedUserRole = role;

      await refreshSession();

      _error = null;
    } catch (_) {
      _error = 'Unable to switch role. Try again.';
    }

    _setLoading(false);
  }

  /// ================= SESSION =================

  Future<void> refreshSession() async {
    try {
      final freshUser = await _authService.getCurrentUser();
      _user = freshUser;
      _isGuest = freshUser == null;

      if (freshUser != null) {
        await _loadUserMeta(freshUser.uid);
      }

      _error = null;
    } catch (_) {
      _error = 'Session refresh failed. Restart app.';
    }

    notifyListeners();
  }

  /// ================= GUEST =================

  Future<void> continueAsGuest() async {
    _setLoading(true);

    try {
      final now = DateTime.now();

      _user = AppUser(
        uid: now.millisecondsSinceEpoch.toString(),
        name: 'Guest',
        email: 'guest@mythica.com',
        role: UserRole.reader,
        phone: '',
        city: '',
        currentMode: UserMode.reader,
        createdAt: now,
        updatedAt: now,
        gender: 'unknown',
        selectedGenres: const [],
        favoriteGenres: const [],
        hasCompletedOnboarding: true,
        hasActiveSubscription: false,
      );

      _isGuest = true;
      _requiresProfileCompletion = false;
      _isAdmin = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// ================= SIGNUP =================

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!_isValidEmail(email) || name.trim().isEmpty) {
      _setError('Enter valid details');
      return false;
    }

    _setLoading(true);

    try {
      final user = await _authService.signUp(
        email: email.trim(),
        password: password,
        name: name.trim(),
      );

      _user = user;
      _isGuest = false;

      await _loadUserMeta(user.uid);

      _clearError();
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ================= LOGIN =================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (!_isValidEmail(email) || password.trim().isEmpty) {
      _setError('Enter valid email & password');
      return false;
    }

    _setLoading(true);

    try {
      final user = await _authService.login(
        email: email.trim(),
        password: password,
      );

      _user = user;
      _isGuest = false;

      await _loadUserMeta(user.uid);

      _clearError();
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ================= GOOGLE =================

  Future<bool> signInWithGoogle() async {
    _setLoading(true);

    try {
      final result = await _authService.signInWithGoogle();

      _user = result.user;
      _isGuest = false;

      await _loadUserMeta(result.user.uid);

      _requiresProfileCompletion =
          result.isFirstTime || _requiresProfileCompletion;

      _clearError();
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ================= MICROSOFT =================

  Future<bool> signInWithMicrosoft() async {
    _setLoading(true);

    try {
      final result = await _authService.signInWithMicrosoft();

      _user = result.user;
      _isGuest = false;

      await _loadUserMeta(result.user.uid);

      _requiresProfileCompletion =
          result.isFirstTime || _requiresProfileCompletion;

      _clearError();
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ================= PROFILE =================

  Future<bool> completeProfile({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (_user == null) return false;

    _setLoading(true);

    try {
      await _authService.completeProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        phone: phone,
      );

      final firebaseUser = _authService.currentFirebaseUser;

      if (firebaseUser != null) {
        if (firebaseUser.email != email) {
          await firebaseUser.verifyBeforeUpdateEmail(email);
        }
        await firebaseUser.updatePassword(password);
      }

      _user = _user!.copyWith(name: name, phone: phone);
      _requiresProfileCompletion = false;

      _clearError();
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveGenres(List<String> genres) async {
    if (_user == null) return;

    await _authService.setUserGenres(_user!.uid, genres);

    _user = _user!.copyWith(
      selectedGenres: genres,
      hasCompletedOnboarding: true,
    );

    notifyListeners();
  }

  Future<void> savePhotoUrl(String url) async {
    if (_user == null) return;

    await _authService.setUserPhotoUrl(_user!.uid, url);

    _user = _user!.copyWith(
      photoUrl: url,
      profileImageUrl: url,
    );

    notifyListeners();

  }
  

  /// ================= LOGOUT =================

  Future<void> logout() async {
    await _authService.logout();

    _user = null;
    _isGuest = true;
    _selectedUserRole = null;
    _requiresProfileCompletion = false;
    _isAdmin = false;

    notifyListeners();
  }

  /// ================= HELPERS =================

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(email.trim());
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  String _parseAuthError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Invalid email or password';
        case 'invalid-email':
          return 'Invalid email';
        case 'user-disabled':
          return 'Account disabled';
        case 'too-many-requests':
          return 'Too many attempts. Try later';
        default:
          return e.message ?? 'Auth failed';
      }
    }
    return e.toString();
  }
}