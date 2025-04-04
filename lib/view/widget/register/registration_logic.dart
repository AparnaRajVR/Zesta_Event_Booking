// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/model/user_model.dart';
// import 'package:z_organizer/viewmodel/image_upload_viewmodel.dart';

// class RegisterUserWidget extends ConsumerStatefulWidget {
//   final String fullName;
//   final String email;
//   final String phone;
//   final String organizerType;
//   final String orgName;
//   final String address;
//   final File? profileImage;

//   const RegisterUserWidget({
//     super.key,
//     required this.fullName,
//     required this.email,
//     required this.phone,
//     required this.organizerType,
//     required this.orgName,
//     required this.address,
//     required this.profileImage,
//   });

//   @override
//   ConsumerState<RegisterUserWidget> createState() => _RegisterUserWidgetState();
// }

// class _RegisterUserWidgetState extends ConsumerState<RegisterUserWidget> {
//  Future<void> registerUser() async {
//     try {
//       // Ensure the form is valid before proceeding
//       if (!_formKey.currentState!.validate()) {
//         return;
//       }

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User not logged in!')),
//         );
//         return;
//       }

//       String? imageUrl;
//       // Upload image if selected
//       if (selectedImage != null) {
//         imageUrl = await ref.read(imageUploadProvider.notifier).uploadImage(selectedImage!);
//       }

//       // Create UserModel object
//       UserModel newUser = UserModel(
//         fullName: nameController.text,
//         email: emailController.text,
//         phone: phoneController.text,
//         organizerType: selectedOrganizerType ?? '',
//         orgName: orgNameController.text,
//         address: addressController.text,
//         profileImageUrl: imageUrl,
//       );

//       // Save to Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set(newUser.toJson());

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Registration successful!')),
//       );

//       // Optionally navigate away or clear fields
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

// }