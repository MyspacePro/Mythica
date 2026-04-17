import 'package:cloud_firestore/cloud_firestore.dart';

class RoleService {
  RoleService._();
  static final RoleService instance = RoleService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> userRef(String uid) =>
      _firestore.collection('users').doc(uid);

  /// ✅ SAFE STREAM (no crash, no freeze)
  Stream<Map<String, dynamic>?> userProfileStream(String uid) {
    return userRef(uid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return snapshot.data();
        })
        .handleError((_) {
          // Prevent stream crash in production
        });
  }

  /// ✅ SAFE FETCH
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final snapshot = await userRef(uid)
          .get()
          .timeout(const Duration(seconds: 8));

      if (!snapshot.exists) return null;

      return snapshot.data();
    } catch (_) {
      return null; // prevent app crash
    }
  }

  Future<String?> fetchRole(String uid) async {
    final profile = await fetchUserProfile(uid);
    return profile?['role']?.toString();
  }

  bool isWriterOrAdmin(String? role) =>
      role == 'writer' || role == 'admin';

  bool isReader(String? role) => role == 'reader';

  /// ✅ SAFE ROLE SWITCH
  Future<void> switchRole({
    required String uid,
    required String targetRole,
  }) async {
    if (targetRole != 'reader' && targetRole != 'writer') {
      throw ArgumentError(
          'Unsupported role switch target: $targetRole');
    }

    try {
      await userRef(uid).update({
        'role': targetRole,
        'currentMode': targetRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Do not crash app if update fails
    }
  }
}