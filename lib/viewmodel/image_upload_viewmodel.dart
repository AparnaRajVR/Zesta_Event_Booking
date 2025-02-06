

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/cloudinary/img_service.dart';
import 'package:z_organizer/providers/cloudinary_provider.dart';

class ImageUploadViewModel extends StateNotifier<AsyncValue<String>> {
  final CloudinaryService _cloudinaryService;

  ImageUploadViewModel(this._cloudinaryService) : super(const AsyncValue.data(''));

  Future<void> uploadImage(File image) async {
    state = const AsyncValue.loading();
    try {
      final imageUrl = await _cloudinaryService.uploadImage(image);
      state = AsyncValue.data(imageUrl);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Provider for the ImageUploadViewModel
final imageUploadProvider = StateNotifierProvider<ImageUploadViewModel, AsyncValue<String>>((ref) {
  final cloudinaryService = ref.watch(cloudinaryServiceProvider);
  return ImageUploadViewModel(cloudinaryService);
});

// New provider to store the selected image before uploading
final selectedImageProvider = StateProvider<File?>((ref) => null);
