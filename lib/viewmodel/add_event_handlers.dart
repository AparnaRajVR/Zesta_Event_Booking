import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/services/event_service.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';

class AddEventHandlers {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;

  AddEventHandlers({
    required this.formKey,
    required this.controllers,
  });

  // Date Picker
  Future<void> pickDate(BuildContext context, WidgetRef ref) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) {
      ref.read(eventDateProvider.notifier).state = pickedDate;
    }
  }

  // Start Time Picker
  Future<void> pickStartTime(BuildContext context, WidgetRef ref) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)
        ),
        child: child!,
      ),
    );
    if (pickedTime != null) {
      ref.read(startTimeProvider.notifier).state = 
        DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
    }
  }

  // End Time Picker
  Future<void> pickEndTime(BuildContext context, WidgetRef ref) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)
        ),
        child: child!,
      ),
    );
    if (pickedTime != null) {
      ref.read(endTimeProvider.notifier).state = 
        DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
    }
  }

  // Improved Image Picker with limits
  Future<void> pickImages(WidgetRef ref) async {
    try {
      final currentImages = ref.read(selectedImageProvider);
      final remainingSlots = 10 - currentImages.length; // Limit to 10 images total
      
      if (remainingSlots <= 0) {
        // Show message if limit reached
        return;
      }

      final pickedFiles = await ImagePicker().pickMultiImage();
      
      if (pickedFiles.isNotEmpty) {
        // Take only the remaining slots
        final imagesToAdd = pickedFiles.take(remainingSlots).toList();
        
        ref.read(selectedImageProvider.notifier).state = [
          ...currentImages,
          ...imagesToAdd.map((file) => File(file.path)),
        ];
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Create Event with improved error handling
  Future<void> createEvent(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get all required data
      final formState = formKey.currentState;
      final images = ref.read(selectedImageProvider);
      final date = ref.read(eventDateProvider);
      final start = ref.read(startTimeProvider);
      final end = ref.read(endTimeProvider);
      final selectedCategoryId = ref.read(selectedCategoryIdProvider);
      final selectedAgeLimit = ref.read(selectedAgeLimitProvider);
      final selectedLanguages = ref.read(selectedLanguagesProvider);

      // Validation
      if (!_validateForm(
        formState,
        images,
        date,
        start,
        selectedCategoryId,
        selectedAgeLimit,
        context,
      )) {
        Navigator.pop(context); // Close loading dialog
        return;
      }

      // Create event
      final firebaseService = ref.read(firebaseServiceProvider);
      await _performEventCreation(
        firebaseService,
        images,
        date!,
        start!,
        end,
        selectedCategoryId!,
        selectedAgeLimit!,
        selectedLanguages,
      );

      // Close loading dialog
      Navigator.pop(context);

      // Clear fields and show success
      _clearAllFields(ref);
      _showSuccessMessage(context);
      
      // Navigate to dashboard
      _navigateToDashboard(context);
      
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      _showErrorMessage(context, e.toString(), ref);
      print('Event creation error: $e');
    }
  }

  bool _validateForm(
    FormState? formState,
    List<File> images,
    DateTime? date,
    DateTime? start,
    String? selectedCategoryId,
    String? selectedAgeLimit,
    BuildContext context,
  ) {
    if (formState == null || !formState.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields correctly')),
      );
      return false;
    }

    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return false;
    }

    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event date')),
      );
      return false;
    }

    if (start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start time')),
      );
      return false;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return false;
    }

    if (selectedAgeLimit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select age limit')),
      );
      return false;
    }

    return true;
  }

  // Improved Event Creation with batch image upload
  Future<void> _performEventCreation(
    dynamic firebaseService,
    List<File> images,
    DateTime date,
    DateTime start,
    DateTime? end,
    String selectedCategoryId,
    String selectedAgeLimit,
    List<String> selectedLanguages,
  ) async {
    try {
      // Upload images in smaller batches to avoid timeouts
      List<String> imageUrls = [];
      const batchSize = 3; // Upload 3 images at a time
      
      for (int i = 0; i < images.length; i += batchSize) {
        final batch = images.skip(i).take(batchSize).toList();
        final batchUrls = await firebaseService.uploadImages(batch);
        imageUrls.addAll(batchUrls);
      }
      
      // Create event with uploaded image URLs
      await firebaseService.createEvent(
        name: controllers['name']!.text.trim(),
        organizerName: controllers['organizerName']!.text.trim(),
        description: controllers['description']!.text.trim(),
        address: controllers['address']!.text.trim(),
        city: controllers['city']!.text.trim(),
        categoryId: selectedCategoryId,
        duration: controllers['duration']!.text.trim(),
        ageLimit: [selectedAgeLimit],
        languages: selectedLanguages.isNotEmpty ? selectedLanguages : ['English'],
        date: date,
        startTime: start,
        endTime: end,
        imageUrls: imageUrls,
        ticketPrice: double.parse(controllers['ticketPrice']!.text.trim()),
        ticketCount: int.parse(controllers['ticketCount']!.text.trim()),
      );
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Improved Clear All Fields with proper provider reset
  void _clearAllFields(WidgetRef ref) {
    try {
      // Clear text controllers
      controllers.forEach((_, controller) {
        controller.clear();
      });

      // Reset providers with proper default values
      ref.read(selectedImageProvider.notifier).state = <File>[];
      ref.read(eventDateProvider.notifier).state = null;
      ref.read(startTimeProvider.notifier).state = null;
      ref.read(endTimeProvider.notifier).state = null;
      
      // Reset to first available category instead of null
      final categories = ref.read(eventCategoriesProvider).value;
      if (categories != null && categories.isNotEmpty) {
        ref.read(selectedCategoryIdProvider.notifier).state = categories.first['id'] as String;
      }
      
      // Reset to first age limit instead of null
      ref.read(selectedAgeLimitProvider.notifier).state = 'All Ages';
      ref.read(selectedLanguagesProvider.notifier).state = <String>[];
      
    } catch (e) {
      print('Error clearing fields: $e');
    }
  }

  // Navigation Helper
  void _navigateToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
      (route) => false,
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event Created Successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String error, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to create event: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => createEvent(context, ref),
        ),
      ),
    );
  }
}