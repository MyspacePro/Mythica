import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class SubscriptionService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Checks and auto-downgrades expired users
  static Future<AppUser?> validateSubscription(AppUser? user) async {
    if (user == null) return null;

    // If not premium, nothing to validate
    if (!user.isPremium) return user;

    // If expiry null, treat as invalid
    if (user.subscriptionExpiry == null) {
      return await _downgradeUser(user);
    }

    // If expired
    if (user.subscriptionExpiry!.isBefore(DateTime.now())) {
      return await _downgradeUser(user);
    }

    return user;
  }

  static Future<AppUser> _downgradeUser(AppUser user) async {
    final updatedUser = user.copyWith(
      isPremium: false,
      subscriptionExpiry: null,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'isPremium': false,
      'subscriptionExpiry': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return updatedUser;
  }
}
