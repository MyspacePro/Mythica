import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsGuest = 'is_guest';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save Guest Session
  static Future<void> saveGuestSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuest, true);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// Save Logged-in Session
  static Future<void> saveLoggedInSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuest, false);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Clear Session (Logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsGuest);
    await prefs.remove(_keyIsLoggedIn);
  }

  /// Read Session
  static Future<SessionResult> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool(_keyIsGuest) ?? false;
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (isGuest) return SessionResult.guest;
    if (isLoggedIn) return SessionResult.loggedIn;

    return SessionResult.none;
  }
}

enum SessionResult {
  guest,
  loggedIn,
  none,
}
