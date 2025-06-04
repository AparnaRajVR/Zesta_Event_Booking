import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/profle_edit_provider.dart';

class OrganizerEditProfilePage extends ConsumerWidget {
  const OrganizerEditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(profileEditControllerProvider.notifier);
    final state = ref.watch(profileEditControllerProvider);

    // Use FutureBuilder to get initial profile data
    return FutureBuilder<Map<String, dynamic>?>(
      future: controller.getCurrentUserProfile(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        // Data loaded
        final profileData = snapshot.data ?? {};
        final displayNameController = TextEditingController(text: profileData['displayName'] ?? '');
        final bioController = TextEditingController(text: profileData['bio'] ?? '');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: ValueKey('edit_profile_form'), // Stateless, so use a ValueKey
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () => _showImagePickerOptions(context, ref),
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.deepPurple.shade100,
                            backgroundImage: controller.pickedImage != null
                                ? FileImage(controller.pickedImage!)
                                : (controller.uploadedPhotoUrl != null
                                    ? NetworkImage(controller.uploadedPhotoUrl!)
                                    : null) as ImageProvider?,
                            child: controller.pickedImage == null &&
                                    controller.uploadedPhotoUrl == null
                                ? const Icon(Icons.camera_alt, size: 40)
                                : null,
                          ),
                          if (controller.pickedImage != null || controller.uploadedPhotoUrl != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeImage();
                                  // No setState needed, Riverpod will rebuild
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a display name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: const Icon(Icons.info),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    maxLength: 150,
                  ),
                  const SizedBox(height: 24),
                  state.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    data: (_) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _saveProfile(
                        context,
                        controller,
                        displayNameController.text,
                        bioController.text,
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
    final controller = ref.read(profileEditControllerProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile(
    BuildContext context,
    ProfileEditController controller,
    String displayName,
    String bio,
  ) async {
    try {
      String? photoUrl;
      if (controller.pickedImage != null) {
        photoUrl = await controller.uploadToCloudinary(controller.pickedImage!);
      }
      await controller.updateProfile(
        displayName: displayName,
        bio: bio,
        photoUrl: photoUrl,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ${e.toString()}')),
      );
    }
  }
}
