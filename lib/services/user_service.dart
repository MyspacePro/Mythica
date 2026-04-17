import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data();
  }

  Future<bool> userExists(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists;
  }

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    String role = 'reader',
    List<String> genres = const <String>[],
    String photoUrl = '',
    required bool profileCompleted,
  }) async {
    await _users.doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'genres': genres,
      'photoUrl': photoUrl,
      'profileCompleted': profileCompleted,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> createSignupProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _users.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': 'reader',
      'currentMode': 'reader',
      'isPremium': false,
      'followersCount': 0,
      'followingCount': 0,
      'totalEarnings': 0,
      'availableBalance': 0,
      'premiumActivatedAt': null,
      'premiumExpiry': null,
      'genres': <String>[],
      'photoUrl': '',
      'profileCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateRole({
    required String uid,
    required String role,
  }) async {
    await _users.doc(uid).set({'role': role}, SetOptions(merge: true));
  }

  Future<void> completeGenres({
    required String uid,
    required List<String> genres,
  }) async {
    await _users.doc(uid).set({
      'genres': genres,
      'profileCompleted': true,
    }, SetOptions(merge: true));
  }

  bool isAdmin(Map<String, dynamic>? data) => data?['role'] == 'admin';

  bool isProfileCompleted(Map<String, dynamic>? data) =>
      data?['profileCompleted'] == true;

  String? roleOf(Map<String, dynamic>? data) => data?['role']?.toString();
}
