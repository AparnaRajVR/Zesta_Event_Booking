// edit_event_page.dart - Main Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/services/event_service.dart';
import 'package:z_organizer/view/screen/main_screens/event_details.dart';
import 'package:z_organizer/view/widget/event/edit_event_form.dart';

class EditEventPage extends ConsumerStatefulWidget {
  final EventModel event;
  
  const EditEventPage({super.key, required this.event});

  @override
  // ignore: library_private_types_in_public_api
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late final TextEditingController nameController;
  late final TextEditingController organizerNameController;
  late final TextEditingController descriptionController;
  late final TextEditingController addressController;
  late final TextEditingController cityController;
  late final TextEditingController durationController;
  late final TextEditingController ticketPriceController;
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(existingImagesProvider.notifier).state = List<String>.from(widget.event.images);
    });
    _initializeControllers();
    _initializeProviders();
  }
  
  void _initializeControllers() {
    nameController = TextEditingController(text: widget.event.name);
    organizerNameController = TextEditingController(text: widget.event.organizerName);
    descriptionController = TextEditingController(text: widget.event.description);
    addressController = TextEditingController(text: widget.event.address);
    cityController = TextEditingController(text: widget.event.city);
    durationController = TextEditingController(text: widget.event.duration);
    ticketPriceController = TextEditingController(text: widget.event.ticketPrice.toString());
  }
  
  void _initializeProviders() {
    Future(() {
      if (ref.read(eventDateProvider) == null && widget.event.date != null) {
        ref.read(eventDateProvider.notifier).state = widget.event.date;
      }
      
      if (ref.read(startTimeProvider) == null && widget.event.startTime != null) {
        ref.read(startTimeProvider.notifier).state = widget.event.startTime;
      }
      
      if (ref.read(endTimeProvider) == null && widget.event.endTime != null) {
        ref.read(endTimeProvider.notifier).state = widget.event.endTime;
      }
      
      if (ref.read(selectedCategoryIdProvider) == null && widget.event.categoryId.isNotEmpty) {
        ref.read(selectedCategoryIdProvider.notifier).state = widget.event.categoryId;
      }
      
      if (ref.read(selectedLanguagesProvider).isEmpty && widget.event.languages.isNotEmpty) {
        ref.read(selectedLanguagesProvider.notifier).state = List.from(widget.event.languages);
      }
      
      if (widget.event.ageLimit.isNotEmpty) {
        ref.read(selectedAgeLimitProvider.notifier).state = widget.event.ageLimit.first;
      }
    });
  }
  
  @override
  void dispose() {
    nameController.dispose();
    organizerNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    durationController.dispose();
    ticketPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textlight,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveEvent(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: EditEventFormWidget(
              event: widget.event,
              nameController: nameController,
              organizerNameController: organizerNameController,
              descriptionController: descriptionController,
              addressController: addressController,
              cityController: cityController,
              durationController: durationController,
              ticketPriceController: ticketPriceController,
              onSave: () => _saveEvent(context),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving changes...')),
      );
      
      final selectedImages = ref.read(selectedImageProvider);
      List<String> newImageUrls = [];
      
      if (selectedImages.isNotEmpty) {
        final firebaseService = ref.read(firebaseServiceProvider);
        newImageUrls = await firebaseService.uploadImages(selectedImages);
      }
      
      final allImageUrls = [...widget.event.images, ...newImageUrls];
      
      
      final selectedAgeLimit = ref.read(selectedAgeLimitProvider);
      List<String> ageLimits = selectedAgeLimit != null 
          ? [selectedAgeLimit] 
          : List.from(widget.event.ageLimit);
      
      final updatedEvent = widget.event.copyWith(
        name: nameController.text,
        organizerName: organizerNameController.text,
        description: descriptionController.text,
        address: addressController.text,
        city: cityController.text,
        duration: durationController.text,
        ticketPrice: double.parse(ticketPriceController.text),
        date: ref.read(eventDateProvider),
        startTime: ref.read(startTimeProvider),
        endTime: ref.read(endTimeProvider),
        categoryId: ref.read(selectedCategoryIdProvider) ?? widget.event.categoryId,
        ageLimit: ageLimits,
        languages: ref.read(selectedLanguagesProvider),
        images: allImageUrls,
      );
      
      // Update the event in Firestore
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update(updatedEvent.toMap());
      
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );
      
      // Navigate back to event details
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => EventDetailsPage(event: updatedEvent,)),
      );
      
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating event: $e')),
      );
    }
  }
}



