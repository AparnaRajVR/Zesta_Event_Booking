

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/services/category_service.dart';

final selectedImageProvider = StateProvider<List<File>>((ref) => []);
final eventDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final endTimeProvider = StateProvider<DateTime?>((ref) => null);
final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);
final selectedAgeLimitProvider = StateProvider<String?>((ref) => null);
final selectedLanguagesProvider = StateProvider<List<String>>((ref) => []);

final categoryServiceProvider = Provider((ref) => CategoryService());

final eventCategoriesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final categoryService = ref.read(categoryServiceProvider);
  return categoryService.getCategories();
});


final eventsProvider = StreamProvider<List<EventModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('events')
      .where('organizerId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList());
});
