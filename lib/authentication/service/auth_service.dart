

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Import Firestore
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ✅ Firestore instance

  AuthServices(this._firebaseAuth);

  // Stream to track authentication state changes (logged-in or logged-out)
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  // ✅ **Sign In with Email & Password**
  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  // ✅ **Sign Up (Register) New User**
  Future<String> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match"; // 🔹 Password validation check
    }

    try {
      // 🔹 **Create user in Firebase Auth**
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔹 **Save user info in Firestore**
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "fullName": fullName,
        "email": email,
        "uid": userCredential.user!.uid,
        "createdAt": DateTime.now(),
      });

      return "SignUp successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  // ✅ **Sign Out**
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // ✅ **Google Sign-In**
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google Sign-In aborted"; 

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // 🔹 **Check if new user and store additional info**
      final userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "fullName": googleUser.displayName ?? "No Name",
          "email": googleUser.email,
          "uid": userCredential.user!.uid,
          "createdAt": DateTime.now(),
        });
      }

      return "Google Sign-In successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    } catch (e) {
      return 'An error occurred during Google Sign-In';
    }
  }

  // ✅ **Get User Details from Firestore**
  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      return null;
    }
  }

  
}
