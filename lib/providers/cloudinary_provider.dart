

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:z_organizer/cloudinary/img_service.dart';


final cloudinaryProvider = Provider<CloudinaryPublic>((ref) {
  return CloudinaryPublic('dbu2ez12r', 'my_files', cache: false);
});

// CloudinaryService provider
final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  final cloudinary = ref.watch(cloudinaryProvider);
  return CloudinaryService(cloudinary);
});
