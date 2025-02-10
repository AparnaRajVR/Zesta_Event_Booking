
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._firebaseAuth);

  
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

 
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  /// Creates a new user account with email, password, and additional user details
  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    Map<String, dynamic>? userDetails, 
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.sendEmailVerification();

      final userId = userCredential.user!.uid;

      // Step 1: Save Basic User Data in the "users" Collection
      await _firestore.collection("users").doc(userId).set({
        "uid": userId,
        "fullName": fullName,
        "email": email,
        "createdAt": DateTime.now(),
      });

     
      if (userDetails != null) {
        await _firestore
            .collection("users")
            .doc(userId)
            .collection("UserDetails")
            .add(userDetails);
      }

      return "SignUp successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }


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

      // Save user details if first time sign-in
      final userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "fullName": googleUser.displayName ?? "No Name",
          "email": googleUser.email,
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

  /// Retrieves user details from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection("users").doc(user.uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      return null;
    }
  }

  /// Retrieves extended user details from the "UserDetails" subcollection
  Future<List<Map<String, dynamic>>> getUserDetailsFromSubcollection() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return [];

      final querySnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("UserDetails")
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Checks if the current user's email is verified
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  /// Sends email verification to the current user
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
