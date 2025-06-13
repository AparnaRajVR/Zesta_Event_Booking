import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/view/widget/glass_container.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;

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
        widget.onImageSelected(selectedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectImage(context),
      child: GlassEffect(
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            //  border: Border.all(color: Colors.white),
             borderRadius: BorderRadius.circular(8.0),
            color:
            Colors.white.withOpacity(0.2),
           
            
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
                      'Tap to choose an Document',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: const Color.fromARGB(255, 82, 81, 81)),
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
                      // padding: const EdgeInsets.all(4),
                      // child: const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
