import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

final profileEditControllerProvider = StateNotifierProvider<ProfileEditController, AsyncValue<void>>((ref) {
  return ProfileEditController();
});

class ProfileEditController extends StateNotifier<AsyncValue<void>> {
  ProfileEditController() : super(const AsyncData(null));

  File? pickedImage;
  String? uploadedPhotoUrl;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage = File(picked.path);
    }
  }

  Future<String?> uploadToCloudinary(File file) async {
    try {
      final cloudinary = CloudinaryPublic('dbu2ez12r', 'my_files', cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path, resourceType: CloudinaryResourceType.Image),
      );
      uploadedPhotoUrl = response.secureUrl;
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile({
    required String displayName,
    required String bio,
    String? photoUrl,
  }) async {
    state = const AsyncLoading();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user');
      final data = <String, dynamic>{
        'displayName': displayName,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (photoUrl != null) data['photoUrl'] = photoUrl;
      await FirebaseFirestore.instance.collection('organizers').doc(user.uid).update(data);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
