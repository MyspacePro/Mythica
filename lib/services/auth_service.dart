import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mythica/services/user_service.dart';
import '../../models/user_model.dart';

typedef AuthResult = ({AppUser user, bool isFirstTime});

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// ==============================
  /// GET CURRENT USER
  /// ==============================
  User? get currentFirebaseUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// ==============================
  /// EMAIL SIGNUP
  /// ==============================
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(code: 'signup-failed');
      }

      await _userService.createSignupProfile(
        uid: firebaseUser.uid,
        name: name,
        email: email.trim(),
      );

      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      rethrow;
    }
  }

  /// ==============================
  /// EMAIL LOGIN
  /// ==============================
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(code: 'login-failed');
      }

      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      rethrow;
    }
  }

  /// ==============================
  /// GOOGLE LOGIN
  /// ==============================
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(code: 'aborted-by-user');
      }

      final googleAuth = await googleUser.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(cred);

      final firebaseUser = userCred.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(code: 'invalid-credential');
      }

      final doc = await _safeDoc(firebaseUser.uid);
      final isFirstTime = doc == null;

      final user = await _getOrCreateUser(firebaseUser);

      return (user: user, isFirstTime: isFirstTime);
    } catch (e) {
      rethrow;
    }
  }

  /// ==============================
  /// MICROSOFT LOGIN
  /// ==============================
  Future<AuthResult> signInWithMicrosoft() async {
    try {
      final provider = OAuthProvider("microsoft.com");

      final userCred = await _auth.signInWithProvider(provider);
      final firebaseUser = userCred.user;

      if (firebaseUser == null) {
        throw FirebaseAuthException(code: 'invalid-credential');
      }

      final doc = await _safeDoc(firebaseUser.uid);
      final isFirstTime = doc == null;

      final user = await _getOrCreateUser(firebaseUser);

      return (user: user, isFirstTime: isFirstTime);
    } catch (e) {
      rethrow;
    }
  }

  /// ==============================
  /// GET CURRENT USER SAFE
  /// ==============================
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      return await _getOrCreateUser(firebaseUser)
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

  /// ==============================
  /// GET USER DOC
  /// ==============================
  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final doc = await _users.doc(uid)
          .get()
          .timeout(const Duration(seconds: 6));

      return doc.data();
    } catch (_) {
      return null;
    }
  }

  /// ==============================
  /// PROFILE COMPLETION
  /// ==============================
  Future<bool> isProfileCompleted(String uid) async {
    final data = await getUserDocument(uid);
    return (data?['profileCompleted'] as bool?) ?? false;
  }

  /// ==============================
  /// SET ROLE
  /// ==============================
  Future<void> setUserRole({
    required String uid,
    required String role,
  }) async {
    await _users.doc(uid).set({
      'role': role,
      'currentMode': role,
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ==============================
  /// COMPLETE PROFILE
  /// ==============================
  Future<void> completeProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _users.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ==============================
  /// PHOTO
  /// ==============================
  Future<void> setUserPhotoUrl(String uid, String photoUrl) async {
    await _users.doc(uid).update({
      'photoUrl': photoUrl,
      'profileImageUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==============================
  /// GENRES
  /// ==============================
  Future<void> setUserGenres(String uid, List<String> genres) async {
    await _users.doc(uid).update({
      'selectedGenres': genres,
      'favoriteGenres': genres,
      'hasCompletedOnboarding': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==============================
  /// LOGOUT
  /// ==============================
  Future<void> logout() async {
    await _auth.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  /// ==============================
  /// UPDATE USER
  /// ==============================
  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  /// ==============================
  /// INTERNAL SAFE DOC
  /// ==============================
  Future<Map<String, dynamic>?> _safeDoc(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  /// ==============================
  /// GET OR CREATE USER
  /// ==============================
  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final existing = await _safeDoc(firebaseUser.uid);

    if (existing != null) {
      return AppUser.fromMap(existing);
    }

    return _createUser(firebaseUser);
  }

  /// ==============================
  /// CREATE USER
  /// ==============================
  Future<AppUser> _createUser(User firebaseUser) async {
    final now = DateTime.now();

    final user = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
      phone: firebaseUser.phoneNumber ?? '',
      city: '',
      gender: '',
      dob: null,
      photoUrl: firebaseUser.photoURL,
      profileImageUrl: firebaseUser.photoURL,
      role: UserRole.reader,
      hasActiveSubscription: false,
      currentMode: UserMode.reader,
      isPremium: false,
      subscriptionExpiry: null,
      writerTrialStart: null,
      isWriterPremium: false,
      premiumActivatedAt: null,
      premiumExpiry: null,
      followersCount: 0,
      followingCount: 0,
      totalEarnings: 0,
      availableBalance: 0,
      hasCompletedOnboarding: false,
      selectedGenres: const [],
      favoriteGenres: const [],
      createdAt: now,
      updatedAt: now,
    );

    await _users.doc(firebaseUser.uid).set({
      ...user.toMap(),
      'profileCompleted': false,
      'role': 'reader',
      'currentMode': 'reader',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return user;
  }
}