import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/services/event_service.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
import 'package:z_organizer/view/widget/event/event_details.dart';
// Import the CustomTextFormField

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
    
    // Initialize controllers
    nameController = TextEditingController(text: widget.event.name);
    organizerNameController = TextEditingController(text: widget.event.organizerName);
    descriptionController = TextEditingController(text: widget.event.description);
    addressController = TextEditingController(text: widget.event.address);
    cityController = TextEditingController(text: widget.event.city);
    durationController = TextEditingController(text: widget.event.duration);
    ticketPriceController = TextEditingController(text: widget.event.ticketPrice.toString());
    
    // Initialize providers with existing event data - safely in initState
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
      
      // Initialize age limit
      if (widget.event.ageLimit.isNotEmpty) {
        ref.read(selectedAgeLimitProvider.notifier).state = widget.event.ageLimit.first;
      }
    });
  }
  
  @override
  void dispose() {
    // Dispose controllers
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
    // Read from providers
    // final selectedImages = ref.watch(selectedImageProvider);
    final selectedDate = ref.watch(eventDateProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final selectedLanguages = ref.watch(selectedLanguagesProvider);
    
    // Fetch categories
    final categories = ref.watch(eventCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: AppColors.appbar,
        foregroundColor: Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, widget.event.images),
                const SizedBox(height: 20),
                
                // Event Name
                CustomTextFormField(
                  controller: nameController,
                  label: 'Event Name',
                  hint: 'Enter event name',
                  prefixIcon: const Icon(Icons.event),
                  validator: (value) => value!.isEmpty ? 'Please enter event name' : null,
                ),
                const SizedBox(height: 16),
                
                // Organizer Name
                CustomTextFormField(
                  controller: organizerNameController,
                  label: 'Organizer Name',
                  hint: 'Enter organizer name',
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) => value!.isEmpty ? 'Please enter organizer name' : null,
                ),
                const SizedBox(height: 16),
                
                // Description
                CustomTextFormField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Enter event description',
                  prefixIcon: const Icon(Icons.description),
                  validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 16),
                
                // Address
                CustomTextFormField(
                  controller: addressController,
                  label: 'Address',
                  hint: 'Enter event address',
                  prefixIcon: const Icon(Icons.location_on),
                  validator: (value) => value!.isEmpty ? 'Please enter address' : null,
                ),
                const SizedBox(height: 16),
                
                // City
                CustomTextFormField(
                  controller: cityController,
                  label: 'City',
                  hint: 'Enter city name',
                  prefixIcon: const Icon(Icons.location_city),
                  validator: (value) => value!.isEmpty ? 'Please enter city' : null,
                ),
                const SizedBox(height: 16),
                
                // Duration
                CustomTextFormField(
                  controller: durationController,
                  label: 'Duration (hours)',
                  hint: 'Enter event duration',
                  prefixIcon: const Icon(Icons.timer),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter duration' : null,
                ),
                const SizedBox(height: 16),
                
                // Ticket Price
                CustomTextFormField(
                  controller: ticketPriceController,
                  label: 'Ticket Price (₹)',
                  hint: 'Enter ticket price',
                  prefixIcon: const Icon(Icons.money),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter ticket price';
                    if (double.tryParse(value) == null) return 'Please enter a valid price';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Category Selection
                categories.when(
                  data: (categoriesList) {
                    List<DropdownMenuItem<String>> items = categoriesList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'],
                        child: Text(category['name']),
                      );
                    }).toList();
                    
                    return CustomTextFormField(
                      label: 'Category',
                      hint: 'Select event category',
                      prefixIcon: const Icon(Icons.category),
                      isDropdown: true,
                      selectedValue: selectedCategoryId,
                      dropdownItems: items,
                      onChanged: (value) {
                        ref.read(selectedCategoryIdProvider.notifier).state = value;
                      },
                      validator: (value) => value == null ? 'Please select a category' : null,
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Failed to load categories'),
                ),
                const SizedBox(height: 16),
                
                // Date Picker
                InkWell(
                  onTap: () => _selectDate(context, selectedDate),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Event Date',
                      hintText: 'Select date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      prefixIconConstraints: const BoxConstraints(minWidth: 60),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Text(
                      selectedDate != null 
                          ? DateFormat('MMMM dd, yyyy').format(selectedDate)
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, true, startTime),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Start Time',
                            hintText: 'Select time',
                            prefixIcon: const Icon(Icons.access_time),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                          ),
                          child: Text(
                            startTime != null 
                                ? DateFormat('h:mm a').format(startTime)
                                : 'Select Time',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, false, endTime),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'End Time',
                            hintText: 'Select time',
                            prefixIcon: const Icon(Icons.access_time),
                            prefixIconConstraints: const BoxConstraints(minWidth: 60),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                          ),
                          child: Text(
                            endTime != null 
                                ? DateFormat('h:mm a').format(endTime)
                                : 'Select Time',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Languages Selection
                const Text(
                  'Languages',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _buildLanguageChips(selectedLanguages),
                ),
                const SizedBox(height: 16),
                
                // Age Limit Selection
                const Text(
                  'Age Limit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _buildAgeLimitChips(widget.event.ageLimit),
                ),
                const SizedBox(height: 24),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _saveEvent(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appbar,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLanguageChips(List<String> selectedLanguages) {
    final languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Kannada', 'Malayalam', 'Bengali', 'Marathi', 'Gujarati'];
    
    return languages.map((language) {
      final isSelected = selectedLanguages.contains(language);
      
      return FilterChip(
        label: Text(language),
        selected: isSelected,
        onSelected: (selected) {
          final currentList = List<String>.from(selectedLanguages);
          if (selected) {
            currentList.add(language);
          } else {
            currentList.remove(language);
          }
          ref.read(selectedLanguagesProvider.notifier).state = currentList;
        },
        selectedColor: AppColors.appbar.withOpacity(0.2),
        checkmarkColor: AppColors.appbar,
      );
    }).toList();
  }

  List<Widget> _buildAgeLimitChips(List<String> currentAgeLimits) {
    final ageLimits = ['All Ages', '13+', '16+', '18+', '21+'];
    final selectedAgeLimit = ref.watch(selectedAgeLimitProvider);
    
    return ageLimits.map((limit) {
      final isSelected = currentAgeLimits.contains(limit) || 
          (selectedAgeLimit != null && selectedAgeLimit == limit);
      
      return FilterChip(
        label: Text(limit),
        selected: isSelected,
        onSelected: (selected) {
          ref.read(selectedAgeLimitProvider.notifier).state = selected ? limit : null;
        },
        selectedColor: AppColors.appbar.withOpacity(0.2),
        checkmarkColor: AppColors.appbar,
      );
    }).toList();
  }

  Widget _buildImageSection(BuildContext context, List<String> existingImages) {
    final selectedImages = ref.watch(selectedImageProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Existing images
              ...existingImages.map((url) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          
                          final updatedImages = List<String>.from(existingImages);
                          updatedImages.remove(url);
                        
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              // New selected images
              ...selectedImages.map((file) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          final updatedImages = List<File>.from(selectedImages);
                          updatedImages.remove(file);
                          ref.read(selectedImageProvider.notifier).state = updatedImages;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              // Add image button
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final currentImages = List<File>.from(ref.read(selectedImageProvider));
      currentImages.add(File(image.path));
      ref.read(selectedImageProvider.notifier).state = currentImages;
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? currentDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      ref.read(eventDateProvider.notifier).state = pickedDate;
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime, DateTime? currentTime) async {
    final TimeOfDay initialTime = currentTime != null 
        ? TimeOfDay(hour: currentTime.hour, minute: currentTime.minute)
        : TimeOfDay.now();
        
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (pickedTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      
      if (isStartTime) {
        ref.read(startTimeProvider.notifier).state = dateTime;
      } else {
        ref.read(endTimeProvider.notifier).state = dateTime;
      }
    }
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving changes...')),
      );
      
      // Upload new images if any
      final selectedImages = ref.read(selectedImageProvider);
      List<String> newImageUrls = [];
      
      if (selectedImages.isNotEmpty) {
        final firebaseService = ref.read(firebaseServiceProvider);
        newImageUrls = await firebaseService.uploadImages(selectedImages);
      }
      
      // Combine existing and new image urls
      final allImageUrls = [...widget.event.images, ...newImageUrls];
      
      // Get the selected age limit
      final selectedAgeLimit = ref.read(selectedAgeLimitProvider);
      List<String> ageLimits = selectedAgeLimit != null 
          ? [selectedAgeLimit] 
          : List.from(widget.event.ageLimit);
      
      // Create updated event using copyWith
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
        MaterialPageRoute(builder: (context) => EventDetailsPage(event: updatedEvent)),
      );
      
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating event: $e')),
      );
    }
  }
}
