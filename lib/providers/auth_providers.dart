


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/authentication/service/auth_service.dart';



// FirebaseAuth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// AuthService provider (note: changed from AuthServices to AuthService)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firebaseAuthProvider));
});

// Authentication state provider (Stream of User changes)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges; // Changed from authStateChange
});
