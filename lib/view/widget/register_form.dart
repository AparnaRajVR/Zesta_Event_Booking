
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/entry/verification_status.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
import 'package:z_organizer/view/widget/image_picker.dart';
import 'package:z_organizer/view/widget/validation_widget.dart';
import '../../viewmodel/image_upload_viewmodel.dart';

class RegisterFormWidget extends ConsumerStatefulWidget {
  final String fullName;
  final String email;

  const RegisterFormWidget({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  ConsumerState<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends ConsumerState<RegisterFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? selectedImage;
  String? selectedOrganizerType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    orgNameController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (selectedImage != null) {
      await ref.read(imageUploadProvider.notifier).uploadImage(selectedImage!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
    }
  }

  Future<void> _registerUser(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Upload image if selected
        String? imageUrl;
        if (selectedImage != null) {
          imageUrl = await ref.read(imageUploadProvider.notifier).uploadImage(selectedImage!);
        }

        // Firestore operation: Store user details in main document
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
          'fullName': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'organizationName': orgNameController.text,
          'organizerType': selectedOrganizerType,
          'documentImage': imageUrl,
          'status': "pending",  // <-- NEW FIELD
        });

        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
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



  @override
  Widget build(BuildContext context) {
    final imageUploadState = ref.watch(imageUploadProvider);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
                setState(() {
                  selectedOrganizerType = value;
                });
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
              onImageSelected: (image) => setState(() => selectedImage = image),
            ),
            const SizedBox(height: 16.0),
           ElevatedButton.icon(
              onPressed: () => _uploadImage(context),
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: imageUploadState.when(
                data: (imageUrl) => Text(
                  imageUrl?.isEmpty ?? true ? 'Upload Image' : 'Uploaded Successfully',
                  style: const TextStyle(color: Colors.white),
                ),
                loading: () => const CircularProgressIndicator(color: Colors.white),
                error: (error, _) => const Text('Upload Failed'),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _registerUser(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Register', 
              style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
