import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OrganizerEditProfilePage extends StatefulWidget {
  const OrganizerEditProfilePage({super.key});

  @override
  State<OrganizerEditProfilePage> createState() => _OrganizerEditProfilePageState();
}

class _OrganizerEditProfilePageState extends State<OrganizerEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  File? _pickedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameCtrl.text = user?.displayName ?? '';
    // You may want to load bio from Firestore or another source if you store it there
    _bioCtrl.text = ''; // Set this to user's bio if available
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user found");

      String? photoUrl = user.photoURL;

      // If a new image is picked, upload it to your storage and get the URL
      if (_pickedImage != null) {
        // TODO: Upload _pickedImage to Firebase Storage and get the download URL
        // photoUrl = await uploadImageAndGetUrl(_pickedImage!);
      }

      await user.updateDisplayName(_nameCtrl.text.trim());
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // If you store bio elsewhere (e.g., Firestore), update it there as well

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepPurple.shade200,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null) as ImageProvider?,
                      child: _pickedImage == null && user?.photoURL == null
                          ? Icon(Icons.person, size: 60, color: Colors.deepPurple.shade700)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.blue, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v == null || v.trim().isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveProfile,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
