
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
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

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource != null) {
      final pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
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
              validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              validator: (value) => value == null || value.isEmpty
                  ? 'Phone number is required'
                  : (!RegExp(r'^\d{10,15}$').hasMatch(value) ? 'Enter a valid phone number' : null),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Organizer Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Type A', child: Text('Type A')),
                DropdownMenuItem(value: 'Type B', child: Text('Type B')),
                DropdownMenuItem(value: 'Type C', child: Text('Type C')),
              ],
              onChanged: (value) {},
              validator: (value) => value == null || value.isEmpty ? 'Please select an organizer type' : null,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: orgNameController,
              label: 'Organization Name',
              hint: 'Enter organization name',
              validator: (value) => value == null || value.isEmpty ? 'Organization name is required' : null,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              controller: addressController,
              label: 'Organization Address',
              hint: 'Enter organization address',
              validator: (value) => value == null || value.isEmpty ? 'Organization address is required' : null,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectImage(context),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (selectedImage != null)
                      Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    if (selectedImage == null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to choose an image',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    if (selectedImage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                              onTap: () => _selectImage(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
  ElevatedButton.icon(
              onPressed: () => _uploadImage(context),
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: imageUploadState.when(
                data: (imageUrl) => Text(imageUrl.isEmpty ? 'Upload Image' : 'Uploaded Successfully'),
                loading: () => const CircularProgressIndicator(color: Colors.white),
                error: (error, _) => const Text('Upload Failed'),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform registration logic
                }
              },
              child: const Text('Register', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
