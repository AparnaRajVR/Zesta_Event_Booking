

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //  Email & Password Sign In
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  //  Email & Password Sign Up + Firestore User Creation
  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    Map<String, dynamic>? userDetails,
  }) async {
    if (password != confirmPassword) return "Passwords do not match";

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;
      await _firestore.collection("users").doc(userId).set({
        "uid": userId,
        "fullName": fullName,
        "email": email,
        "createdAt": DateTime.now(),
        
      });

      if (userDetails != null) {
        await _firestore.collection("users").doc(userId).collection("UserDetails").add(userDetails);
      }

      return "SignUp successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  // 🔹 Google Sign-In
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "Google Sign-In aborted";

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final userId = userCredential.user!.uid;
      final userDoc = await _firestore.collection("users").doc(userId).get();

      if (!userDoc.exists) {
        await _firestore.collection("users").doc(userId).set({
          "uid": userId,
          "fullName": googleUser.displayName ?? "No Name",
          "email": googleUser.email,
          "createdAt": DateTime.now(),
          "status": "pending",
        });
      }

      return "Google Sign-In successful";
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.message}");
      return e.message ?? 'An unknown error occurred';
    } catch (e) {
      log("General Exception: $e");
      return 'An error occurred during Google Sign-In';
    }
  }

  // 🔹 Check Approval Status
  Future<bool> checkApprovalStatus() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.exists && (doc.data()?["status"] == "approved");
  }

  //  User Details
  Future<Map<String, dynamic>?> getUserDetails() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }

  //  User Subcollection 
  Future<List<Map<String, dynamic>>> getUserDetailsFromSubcollection() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return [];

    final querySnapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("UserDetails")
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  //  User Verification Status
  Future<String?> getUserVerificationStatus() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.exists ? doc['status'] : null;
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

