// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthRepository {
//   final FirebaseAuth _firebaseAuth;

//   AuthRepository(this._firebaseAuth);

//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   Future<void> createUserWithEmailAndPassword(String email, String password) async {
//     await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//      await userCredential.user?.sendEmailVerification();
//   }

// Future<bool> isEmailVerified() async {
//   final user = _firebaseAuth.currentUser;
//   await user?.reload(); // Refresh user info to get the latest verification status
//   return user?.emailVerified ?? false;
// }

// Future<void> sendVerificationEmail() async {
//   final user = _firebaseAuth.currentUser;
//   if (user != null && !user.emailVerified) {
//     await user.sendEmailVerification();
//   }
// }

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }

//   Future<UserCredential> signInWithGoogle() async {
//     final googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) throw Exception("Google Sign-In aborted");

//     final googleAuth = await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     return await _firebaseAuth.signInWithCredential(credential);
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    // Send email verification
    await userCredential.user?.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    await user?.reload(); // Refresh user info to get the latest verification status
    return user?.emailVerified ?? false;
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception("Google Sign-In aborted");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }
}
