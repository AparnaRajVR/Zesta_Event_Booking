
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:z_organizer/constant/color.dart';
// import 'package:z_organizer/providers/cloudinary_provider.dart';
// import 'package:z_organizer/view/screen/entry/verification_status.dart';
// import 'package:z_organizer/view/widget/custom_feild.dart';
// import 'package:z_organizer/view/widget/image_picker.dart';
// import 'package:z_organizer/view/widget/validation_widget.dart';

// // Local providers for this screen
// final uploadedImageUrlProvider = StateProvider<String?>((ref) => null);
// final isUploadingProvider = StateProvider<bool>((ref) => false);

// class RegisterFormWidget extends ConsumerStatefulWidget {
//   final String fullName;
//   final String email;

//   const RegisterFormWidget({
//     super.key,
//     required this.fullName,
//     required this.email,
//   });

//   @override
//   ConsumerState<RegisterFormWidget> createState() => _RegisterFormWidgetState();
// }

// class _RegisterFormWidgetState extends ConsumerState<RegisterFormWidget> {
//   late final TextEditingController nameController;
//   late final TextEditingController emailController;
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController orgNameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   File? selectedImage;
//   String? selectedOrganizerType;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.fullName);
//     emailController = TextEditingController(text: widget.email);
//   }

 

//   Future<void> _uploadImage(BuildContext context) async {
//     if (selectedImage != null) {
//       // Set loading state
//       ref.read(isUploadingProvider.notifier).state = true;
      
//       try {
//         final cloudinaryService = ref.read(cloudinaryServiceProvider);
//         final imageUrl = await cloudinaryService.uploadImage(selectedImage!);
        
//         // Update with upload result
//         ref.read(uploadedImageUrlProvider.notifier).state = imageUrl;
//         ref.read(isUploadingProvider.notifier).state = false;
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image uploaded successfully')),
//         );
//       } catch (e) {
//         // Update loading state on error
//         ref.read(isUploadingProvider.notifier).state = false;
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first.')),
//       );
//     }
//   }

//   Future<void> _registerUser(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );

//       try {
//         final currentUser = FirebaseAuth.instance.currentUser;

//         if (currentUser != null) {
//           // Get already uploaded URL or upload new image
//           String? imageUrl = ref.read(uploadedImageUrlProvider);
//           if (selectedImage != null && imageUrl == null) {
//             final cloudinaryService = ref.read(cloudinaryServiceProvider);
//             imageUrl = await cloudinaryService.uploadImage(selectedImage!);
//           }

//           // Firestore operation: Store user details in main document
//           await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
//             'fullName': nameController.text,
//             'email': emailController.text,
//             'phone': phoneController.text,
//             'address': addressController.text,
//             'organizationName': orgNameController.text,
//             'organizerType': selectedOrganizerType,
//             'documentImage': imageUrl,
//             'status': "pending",  
//           });

//           Navigator.of(context).pop();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => SuccessPage()),
//           );
//         } else {
//           throw Exception('User not logged in');
//         }
//       } catch (e) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Registration failed: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isUploading = ref.watch(isUploadingProvider);
//     final uploadedImageUrl = ref.watch(uploadedImageUrlProvider);

//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             CustomTextFormField(
//               controller: nameController,
//               label: 'Full Name',
//               hint: 'Enter your full name',
//               validator: ValidationHelper.validateName,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextFormField(
//               controller: emailController,
//               label: 'Email',
//               hint: 'Enter your email',
//               validator: ValidationHelper.validateEmail,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextFormField(
//               controller: phoneController,
//               label: 'Phone Number',
//               hint: 'Enter your phone number',
//               validator: ValidationHelper.validatePhone,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextFormField(
//               isDropdown: true,
//               label: 'Organizer Type',
//               hint: 'Select organizer type',
//               dropdownItems: const [
//                 DropdownMenuItem(value: 'Institute', child: Text('Institute')),
//                 DropdownMenuItem(value: 'Club', child: Text('Club')),
//                 DropdownMenuItem(value: 'Others', child: Text('Others')),
//               ],
//               selectedValue: selectedOrganizerType,
//               onChanged: (value) {
//                 setState(() {
//                   selectedOrganizerType = value;
//                 });
//               },
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Please select an organizer type' : null,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextFormField(
//               controller: orgNameController,
//               label: 'Organization Name',
//               hint: 'Enter organization name',
//               validator: ValidationHelper.validateName,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextFormField(
//               controller: addressController,
//               label: 'Organization Address',
//               hint: 'Enter organization address',
//               validator: ValidationHelper.validateName,
//             ),
//             const SizedBox(height: 16.0),
//             ImagePickerWidget(
//               onImageSelected: (image) => setState(() => selectedImage = image),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton.icon(
//               onPressed: isUploading ? null : () => _uploadImage(context),
//               icon: const Icon(Icons.upload_file, color: AppColors.textlight),
//               label: isUploading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         color: AppColors.textlight,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : Text(
//                       uploadedImageUrl != null ? 'Uploaded Successfully' : 'Upload Image',
//                       style: const TextStyle(color: AppColors.textlight),
//                     ),
//               style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => _registerUser(context),
//               style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
//               child: const Text(
//                 'Register',
//                 style: TextStyle(color: AppColors.textlight),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/cloudinary_provider.dart';
import 'package:z_organizer/view/screen/entry/verification_status.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
import 'package:z_organizer/view/widget/image_picker.dart';
import 'package:z_organizer/view/widget/validation_widget.dart';

final uploadedImageUrlProvider = StateProvider<String?>((ref) => null);
final isUploadingProvider = StateProvider<bool>((ref) => false);

// New providers for stateless widget
final selectedImageProvider = StateProvider<File?>((ref) => null);
final selectedOrganizerTypeProvider = StateProvider<String?>((ref) => null);

// Controller providers with automatic disposal
final nameControllerProvider = StateProvider.family<TextEditingController, String>((ref, initialValue) {
  final controller = TextEditingController(text: initialValue);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final emailControllerProvider = StateProvider.family<TextEditingController, String>((ref, initialValue) {
  final controller = TextEditingController(text: initialValue);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final phoneControllerProvider = StateProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final addressControllerProvider = StateProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final orgNameControllerProvider = StateProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final formKeyProvider = StateProvider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});



class RegisterFormWidget extends ConsumerWidget {
  final String fullName;
  final String email;

  const RegisterFormWidget({
    super.key,
    required this.fullName,
    required this.email,
  });

  Future<void> _uploadImage(BuildContext context, WidgetRef ref) async {
    final selectedImage = ref.read(selectedImageProvider);
    
    if (selectedImage != null) {
      // Set loading state
      ref.read(isUploadingProvider.notifier).state = true;
      
      try {
        final cloudinaryService = ref.read(cloudinaryServiceProvider);
        final imageUrl = await cloudinaryService.uploadImage(selectedImage);
        
        // Update with upload result
        ref.read(uploadedImageUrlProvider.notifier).state = imageUrl;
        ref.read(isUploadingProvider.notifier).state = false;
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      } catch (e) {
        // Update loading state on error
        ref.read(isUploadingProvider.notifier).state = false;
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
    }
  }

  Future<void> _registerUser(BuildContext context, WidgetRef ref) async {
    final formKey = ref.read(formKeyProvider);
    
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Get controllers
          final nameController = ref.read(nameControllerProvider(fullName));
          final emailController = ref.read(emailControllerProvider(email));
          final phoneController = ref.read(phoneControllerProvider);
          final addressController = ref.read(addressControllerProvider);
          final orgNameController = ref.read(orgNameControllerProvider);
          final selectedOrganizerType = ref.read(selectedOrganizerTypeProvider);
          final selectedImage = ref.read(selectedImageProvider);

          // Get already uploaded URL or upload new image
          String? imageUrl = ref.read(uploadedImageUrlProvider);
          if (selectedImage != null && imageUrl == null) {
            final cloudinaryService = ref.read(cloudinaryServiceProvider);
            imageUrl = await cloudinaryService.uploadImage(selectedImage);
          }

          // Update existing user document with additional details
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
            'fullName': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'address': addressController.text,
            'organizationName': orgNameController.text,
            'organizerType': selectedOrganizerType,
            'documentImage': imageUrl,
            'status': "pending",
            'registrationCompletedAt': DateTime.now(),
          });

          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SuccessPage()),
            );
          }
        } else {
          throw Exception('User not logged in');
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.watch(isUploadingProvider);
    final uploadedImageUrl = ref.watch(uploadedImageUrlProvider);
    final selectedOrganizerType = ref.watch(selectedOrganizerTypeProvider);
    final formKey = ref.watch(formKeyProvider);
    
    // Get controllers
    final nameController = ref.watch(nameControllerProvider(fullName));
    final emailController = ref.watch(emailControllerProvider(email));
    final phoneController = ref.watch(phoneControllerProvider);
    final addressController = ref.watch(addressControllerProvider);
    final orgNameController = ref.watch(orgNameControllerProvider);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              validator: ValidationHelper.validateName,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              validator: ValidationHelper.validateEmail,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              validator: ValidationHelper.validatePhone,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              isDropdown: true,
              label: 'Organizer Type',
              hint: 'Select organizer type',
              dropdownItems: const [
                DropdownMenuItem(value: 'Institute', child: Text('Institute')),
                DropdownMenuItem(value: 'Club', child: Text('Club')),
                DropdownMenuItem(value: 'Others', child: Text('Others')),
              ],
              selectedValue: selectedOrganizerType,
              onChanged: (value) {
                ref.read(selectedOrganizerTypeProvider.notifier).state = value;
              },
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please select an organizer type' : null,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: orgNameController,
              label: 'Organization Name',
              hint: 'Enter organization name',
              validator: ValidationHelper.validateName,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: addressController,
              label: 'Organization Address',
              hint: 'Enter organization address',
              validator: ValidationHelper.validateName,
            ),
            const SizedBox(height: 16.0),
            ImagePickerWidget(
              onImageSelected: (image) {
                ref.read(selectedImageProvider.notifier).state = image;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: isUploading ? null : () => _uploadImage(context, ref),
              icon: const Icon(Icons.upload_file, color: AppColors.textlight),
              label: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.textlight,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      uploadedImageUrl != null ? 'Uploaded Successfully' : 'Upload Image',
                      style: const TextStyle(color: AppColors.textlight),
                    ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _registerUser(context, ref),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text(
                'Register',
                style: TextStyle(color: AppColors.textlight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}