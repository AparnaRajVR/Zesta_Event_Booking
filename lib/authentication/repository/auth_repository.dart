

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication Repository
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 

  AuthRepository(this._firebaseAuth);

  // Listen for Authentication State Changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

 


  /// Sign In with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Create a New User with Email, Password, and Full Name
  Future<void> createUserWithEmailAndPassword(String email, String password, String fullName) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.sendEmailVerification();

    // Save user details in Firestore
    await _firestore.collection("users").doc(userCredential.user!.uid).set({
      "uid": userCredential.user!.uid,
      "fullName": fullName,
      "email": email,
      "createdAt": DateTime.now(),
    });
  }

  // -----------------------------------------------------------------------
  // Email Verification
  // -----------------------------------------------------------------------

  /// Check if Email is Verified
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  /// Send Email Verification
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // -----------------------------------------------------------------------
  // Google Sign-In
  // -----------------------------------------------------------------------

  /// Sign In with Google Account
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception("Google Sign-In aborted");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Save user details in Firestore if the user is signing in for the first time
    final userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
    if (!userDoc.exists) {
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "fullName": googleUser.displayName ?? "No Name",
        "email": googleUser.email,
        "createdAt": DateTime.now(),
      });
    }
  }

  // -----------------------------------------------------------------------
  // User Data Management
  // -----------------------------------------------------------------------

  /// Get User Details from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }

  // -----------------------------------------------------------------------
  // Sign Out
  // -----------------------------------------------------------------------

  /// Sign Out the Current User
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

/// Riverpod Providers
/// -----------------------------------------------------------------------
/// Provides an instance of AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

/// Provides Authentication State as a Stream
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});
