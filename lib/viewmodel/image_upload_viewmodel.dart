

// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/providers/cloudinary_provider.dart';

// class RegImageViewModel extends StateNotifier<AsyncValue<String?>> {
//   final CloudinaryService _cloudinaryService;

//   RegImageViewModel(this._cloudinaryService) : super(const AsyncValue.data(null));


//   Future<String?> uploadImage(File image) async {
//     state = const AsyncValue.loading();
//     try {
//       final imageUrl = await _cloudinaryService.uploadImage(image);
//       state = AsyncValue.data(imageUrl);
//       return imageUrl; 
//     } catch (e) {
//       state = AsyncValue.error(e, StackTrace.current);
//       return null; 
//     }
//   }
// }


// final imageUploadProvider = StateNotifierProvider<RegImageViewModel, AsyncValue<String?>>((ref) {
//   final cloudinaryService = ref.watch(cloudinaryServiceProvider);
//   return RegImageViewModel(cloudinaryService);
// });


// final selectedImageProvider = StateProvider<File?>((ref) => null);


