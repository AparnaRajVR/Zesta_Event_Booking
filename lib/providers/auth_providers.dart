

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authentication/service/auth_service.dart'; 

// FirebaseAuth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// AuthServices provider
final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServices(ref.read(firebaseAuthProvider));
});

// Authentication state provider (Stream of User changes)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServicesProvider).authStateChange;
});


// // **New Provider for Email Verification Status**
// final emailVerifiedProvider = FutureProvider<bool>((ref) async {  // **New provider added**
//   final authServices = ref.watch(authServicesProvider);
//   return await authServices.isEmailVerified();
// });

// // **New Provider to Trigger Send Verification Email**
// final sendVerificationProvider = Provider<void>((ref) {  // **New provider added**
//   final authServices = ref.watch(authServicesProvider);
//   authServices.sendVerificationEmail();  // Trigger email verification send
// });