import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State Providers
final selectedImageProvider = StateProvider<List<File>>((ref) => []);
final eventDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final endTimeProvider = StateProvider<DateTime?>((ref) => null);



// Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});



