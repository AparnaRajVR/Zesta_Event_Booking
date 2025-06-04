
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

final profileEditControllerProvider = StateNotifierProvider<ProfileEditController, AsyncValue<void>>((ref) {
  return ProfileEditController(ref);
});

class ProfileEditController extends StateNotifier<AsyncValue<void>> {
  ProfileEditController(this.ref) : super(const AsyncData(null));
  
  final Ref ref;

  File? pickedImage;
  String? uploadedPhotoUrl;
  bool removedImage = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      pickedImage = File(picked.path);
      removedImage = false;
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      pickedImage = File(picked.path);
      removedImage = false;
    }
  }

  void removeImage() {
    pickedImage = null;
    removedImage = true;
  }

  Future<String?> uploadToCloudinary(File file) async {
    try {
      final cloudinary = CloudinaryPublic('dbu2ez12r', 'my_files', cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      uploadedPhotoUrl = response.secureUrl;
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
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
      if (user == null) throw Exception('No user logged in');

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      } else if (removedImage) {
        await user.updatePhotoURL(null);
      }

      // Update or create Firestore document
      final docRef = FirebaseFirestore.instance.collection('organizers').doc(user.uid);
      
      final data = <String, dynamic>{
        'displayName': displayName,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
        'email': user.email,
      };

      if (photoUrl != null) {
        data['photoUrl'] = photoUrl;
      } else if (removedImage) {
        data['photoUrl'] = null;
      }

      // Use set with merge to create document if it doesn't exist
      await docRef.set(data, SetOptions(merge: true));

      // Reset state
      pickedImage = null;
      removedImage = false;
      
      // Invalidate user profile providers to refresh the UI
      ref.invalidate(userProfileProvider);
      ref.invalidate(combinedUserDataProvider);
      
      state = const AsyncData(null);
    } catch (e, st) {
      print('Profile update error: $e');
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // Method to get current user profile data
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('organizers')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data();
      } else {
        // Return Firebase Auth data if Firestore document doesn't exist
        return {
          'displayName': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL,
          'bio': '',
        };
      }
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  void clearState() {
    pickedImage = null;
    uploadedPhotoUrl = null;
    removedImage = false;
    state = const AsyncData(null);
  }
}

// Add these providers to make them accessible from the controller
// (These should be added to your UserProfileScreen file, but I'm including them here for reference)

// Provider for current user
final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider for user profile data from Firestore
final userProfileProvider = StreamProvider.family<Map<String, dynamic>?, String?>((ref, userId) {
  if (userId == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('organizers')
      .doc(userId)
      .snapshots()
      .map((doc) {
        if (doc.exists) {
          return doc.data();
        }
        return null;
      });
});

// Combined provider that merges Firebase Auth and Firestore data
final combinedUserDataProvider = Provider<AsyncValue<Map<String, dynamic>?>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) {
      if (user == null) return const AsyncData(null);
      
      final profileAsync = ref.watch(userProfileProvider(user.uid));
      return profileAsync.when(
        data: (firestoreData) {
          // Combine Firebase Auth data with Firestore data
          final combinedData = <String, dynamic>{
            'displayName': firestoreData?['displayName'] ?? user.displayName ?? 'Anonymous',
            'email': user.email ?? 'No email',
            'photoUrl': firestoreData?['photoUrl'] ?? user.photoURL,
            'bio': firestoreData?['bio'] ?? '',
            'uid': user.uid,
          };
          return AsyncData(combinedData);
        },
        loading: () => const AsyncLoading(),
        error: (error, stack) {
          // Fallback to Firebase Auth data on error
          final fallbackData = <String, dynamic>{
            'displayName': user.displayName ?? 'Anonymous',
            'email': user.email ?? 'No email',
            'photoUrl': user.photoURL,
            'bio': '',
            'uid': user.uid,
          };
          return AsyncData(fallbackData);
        },
      );
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});