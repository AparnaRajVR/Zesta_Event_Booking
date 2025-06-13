
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';

class EditEventFormWidget extends ConsumerWidget {
  final EventModel event;
  final TextEditingController nameController;
  final TextEditingController organizerNameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController durationController;
  final TextEditingController ticketPriceController;
  final VoidCallback onSave;

  const EditEventFormWidget({
    super.key,
    required this.event,
    required this.nameController,
    required this.organizerNameController,
    required this.descriptionController,
    required this.addressController,
    required this.cityController,
    required this.durationController,
    required this.ticketPriceController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(eventDateProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final selectedLanguages = ref.watch(selectedLanguagesProvider);
    final categories = ref.watch(eventCategoriesProvider);
    final existingImages = ref.watch(existingImagesProvider);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(context, ref, event.images),
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
        _buildDatePicker(context, ref, selectedDate),
        const SizedBox(height: 16),
        
        // Time Pickers
        _buildTimePickers(context, ref, startTime, endTime),
        const SizedBox(height: 16),
        
        // Languages Selection
        _buildLanguagesSection(ref, selectedLanguages),
        const SizedBox(height: 16),
        
        // Age Limit Selection
        _buildAgeLimitSection(ref, event.ageLimit),
        const SizedBox(height: 24),
        
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textlight,
            ),
            child: const Text('Save Changes'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, WidgetRef ref, List<String> existingImages) {
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
            color: AppColors.textaddn,
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
                    ref.read(existingImagesProvider.notifier).state = updatedImages;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.textaddn,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.textlight,
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
                            color: AppColors.textaddn,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.textlight,
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
                  onTap: () => _pickImage(ref),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.textaddn,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textaddn),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: AppColors.textaddn,
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

  Widget _buildDatePicker(BuildContext context, WidgetRef ref, DateTime? selectedDate) {
    return InkWell(
      onTap: () => _selectDate(context, ref, selectedDate),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Event Date',
          hintText: 'Select date',
          prefixIcon: const Icon(Icons.calendar_today),
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.textaddn, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textaddn, width: 1),
          ),
        ),
        child: Text(
          selectedDate != null 
              ? DateFormat('MMMM dd, yyyy').format(selectedDate)
              : 'Select Date',
        ),
      ),
    );
  }

  Widget _buildTimePickers(BuildContext context, WidgetRef ref, DateTime? startTime, DateTime? endTime) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, ref, true, startTime),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Start Time',
                hintText: 'Select time',
                prefixIcon: const Icon(Icons.access_time),
                prefixIconConstraints: const BoxConstraints(minWidth: 60),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textaddn, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.textaddn, width: 1),
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
            onTap: () => _selectTime(context, ref, false, endTime),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'End Time',
                hintText: 'Select time',
                prefixIcon: const Icon(Icons.access_time),
                prefixIconConstraints: const BoxConstraints(minWidth: 60),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textaddn, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.textaddn, width: 1),
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
    );
  }

  Widget _buildLanguagesSection(WidgetRef ref, List<String> selectedLanguages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Languages',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _buildLanguageChips(ref, selectedLanguages),
        ),
      ],
    );
  }

  Widget _buildAgeLimitSection(WidgetRef ref, List<String> currentAgeLimits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age Limit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _buildAgeLimitChips(ref, currentAgeLimits),
        ),
      ],
    );
  }

  List<Widget> _buildLanguageChips(WidgetRef ref, List<String> selectedLanguages) {
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
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
      );
    }).toList();
  }

  List<Widget> _buildAgeLimitChips(WidgetRef ref, List<String> currentAgeLimits) {
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
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
      );
    }).toList();
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final currentImages = List<File>.from(ref.read(selectedImageProvider));
      currentImages.add(File(image.path));
      ref.read(selectedImageProvider.notifier).state = currentImages;
    }
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, DateTime? currentDate) async {
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

  Future<void> _selectTime(BuildContext context, WidgetRef ref, bool isStartTime, DateTime? currentTime) async {
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
}