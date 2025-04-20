
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

final eventCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final categoryService = ref.read(categoryServiceProvider);
  return await categoryService.getCategories().first;
});

// 
final eventsProvider = StreamProvider<List<EventModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('events')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList());
});
