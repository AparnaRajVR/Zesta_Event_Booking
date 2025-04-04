

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:z_organizer/Dependency_injection.dart/cloudinary_image.dart';

// provider provides the cloudinary service
final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService(ref.read(cloudinaryInstance)); 
});

class CloudinaryService {
  final CloudinaryPublic cloudinary;

  CloudinaryService(this.cloudinary);

  Future<String> uploadImage(File image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Upload Failed: $e');
    }
  }
}




