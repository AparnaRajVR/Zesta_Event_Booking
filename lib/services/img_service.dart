

// import 'dart:io';
// import 'package:cloudinary_public/cloudinary_public.dart';

// class CloudinaryService {
//   final CloudinaryPublic _cloudinary;

//   CloudinaryService(this._cloudinary);

//   Future<String> uploadImage(File image) async {
//     try {
//       final response = await _cloudinary.uploadFile(
//         CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
//       );
//       return response.secureUrl;
//     } catch (e) {
//       throw Exception('Failed to upload image: $e');
//     }
//   }
// }
