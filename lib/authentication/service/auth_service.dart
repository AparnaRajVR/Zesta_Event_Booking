

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthServices {
//   final FirebaseAuth _firebaseAuth;

//   AuthServices(this._firebaseAuth);

//   Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

//   Future<String> signIn({required String email, required String password}) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       return "Login successful";
//     } on FirebaseAuthException catch (e) {
//       return e.message ?? 'An unknown error occurred';
//     }
//   }

//   Future<String> signUp({
//     required String fullName,
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     if (password != confirmPassword) {
//       return "Passwords do not match";
//     }

//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return "SignUp successful";
//     } on FirebaseAuthException catch (e) {
//       return e.message ?? 'An unknown error occurred';
//     }
//   }

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }

//   Future<String> signInWithGoogle() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return "Google Sign-In aborted";

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _firebaseAuth.signInWithCredential(credential);
//       return "Google Sign-In successful";
//     } catch (e) {
//       return e is FirebaseAuthException ? e.message ?? 'An unknown error occurred' : 'An error occurred';
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth;

  AuthServices(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  Future<String> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send email verification after user signs up
      // await _firebaseAuth.currentUser?.sendEmailVerification(); // **New line added**
      return "SignUp successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google Sign-In aborted";

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return "Google Sign-In successful";
    } catch (e) {
      return e is FirebaseAuthException ? e.message ?? 'An unknown error occurred' : 'An error occurred';
    }
  }

  // // **New Method to Check Email Verification Status**
  // Future<bool> isEmailVerified() async {  // **New method added**
  //   final user = _firebaseAuth.currentUser;
  //   await user?.reload(); // Reload user info to get the latest verification status
  //   return user?.emailVerified ?? false;  // **New line added**
  // }

  // // **New Method to Resend Verification Email**
  // Future<void> sendVerificationEmail() async { // **New method added**
  //   final user = _firebaseAuth.currentUser;
  //   if (user != null && !user.emailVerified) {
  //     await user.sendEmailVerification();  // **New line added**
  //   }
  // }
}
