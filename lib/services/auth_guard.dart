import 'session_service.dart';

enum AuthDestination {
  guestHome,
  userHome,
  login,
}

class AuthGuard {
  static Future<AuthDestination> decide() async {
    final session = await SessionService.getSession();

    switch (session) {
      case SessionResult.guest:
        return AuthDestination.guestHome;

      case SessionResult.loggedIn:
        return AuthDestination.userHome;

      case SessionResult.none:
      return AuthDestination.login;
    }
  }
}
