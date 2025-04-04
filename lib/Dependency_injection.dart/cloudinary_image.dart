import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:z_organizer/constant/cloud_img.dart';

final cloudinaryInstance = Provider<CloudinaryPublic>((ref) {
  return CloudinaryPublic(CloudinaryConfig.cloudName, CloudinaryConfig.uploadPreset, cache: false);
});
