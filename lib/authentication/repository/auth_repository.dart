
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore for user data storage
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ✅ Firestore instance

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ✅ **Sign In with Email & Password**
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ✅ **Sign Up New User & Save Data to Firestore**
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

  // ✅ **Check if Email is Verified**
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    await user?.reload(); // Refresh user info
    return user?.emailVerified ?? false;
  }

  // ✅ **Send Verification Email**
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // ✅ **Sign Out**
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // ✅ **Google Sign-In**
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception("Google Sign-In aborted");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Store user data in Firestore if it's a new user
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

  // ✅ **Get Current User Details from Firestore**
  Future<Map<String, dynamic>?> getUserDetails() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }
}

// ✅ **Riverpod Provider for Authentication**
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

// ✅ **Riverpod Provider to Stream Auth State**
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});
