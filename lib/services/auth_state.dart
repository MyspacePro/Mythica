import '../../models/user_model.dart';

class AuthState {
  final AppUser? user;
  final bool isGuest;
  final bool isLoggedIn;

  const AuthState({
    this.user,
    this.isGuest = false,
    this.isLoggedIn = false,
  });

  factory AuthState.guest() {
    return const AuthState(
      user: null,
      isGuest: true,
      isLoggedIn: false,
    );
  }

  factory AuthState.loggedIn(AppUser user) {
    return AuthState(
      user: user,
      isGuest: false,
      isLoggedIn: true,
    );
  }

  factory AuthState.loggedOut() {
    return const AuthState(
      user: null,
      isGuest: false,
      isLoggedIn: false,
    );
  }
}
