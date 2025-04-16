
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/services/category_service.dart';

// State Providers
final selectedImageProvider = StateProvider<List<File>>((ref) => []);
final eventDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final endTimeProvider = StateProvider<DateTime?>((ref) => null);
final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);
final selectedAgeLimitProvider = StateProvider<String?>((ref) => null);
final selectedLanguagesProvider = StateProvider<List<String>>((ref) => []);

// Category Service Provider
final categoryServiceProvider = Provider((ref) => CategoryService());

// Categories Provider
final eventCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final categoryService = ref.read(categoryServiceProvider);
  return await categoryService.getCategories().first;
});