import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/viewmodel/add_event_handlers.dart';

class AddEventFormBody extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;
  final AddEventHandlers handlers;

  const AddEventFormBody({
    super.key,
    required this.formKey,
    required this.controllers,
    required this.handlers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> ageLimits = ['All Ages', '5yrs +', '12yrs +', '18yrs +', '21yrs +'];
    final List<String> languages = ['English', 'Malayalam', 'Hindi', 'Tamil'];

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic Information Section
            _buildTextField('Event Name', controllers['name']!),
            _buildTextField('Organizer Name', controllers['organizerName']!),
            _buildTextField('Description', controllers['description']!, maxLines: 3),
            
            // Address Section
            Row(
              children: [
                Expanded(child: _buildTextField('Address', controllers['address']!)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('City', controllers['city']!)),
              ],
            ),
            
            // Event Details Section
            _buildTextField('Duration', controllers['duration']!),
            _buildTextField('Ticket Price', controllers['ticketPrice']!, keyboardType: TextInputType.number),
            _buildTextField('Ticket Count', controllers['ticketCount']!, keyboardType: TextInputType.number),
            
            // Category Dropdown
            Consumer(
              builder: (context, ref, _) {
                return ref.watch(eventCategoriesProvider).when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const Text('No categories available', style: TextStyle(color: Colors.red));
                    }
                    final selectedId = ref.watch(selectedCategoryIdProvider);
                    final selectedCategory = categories.firstWhere(
                      (cat) => cat['id'] == selectedId,
                      orElse: () => categories.first,
                    );
                    return _buildDropdown(
                      'Category',
                      categories.map((cat) => cat['name'] as String).toList(),
                      selectedCategory['name'] as String,
                      (value) {
                        final selected = categories.firstWhere((cat) => cat['name'] == value);
                        ref.read(selectedCategoryIdProvider.notifier).state = selected['id'] as String;
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text(
                    'Failed to load categories: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
            
            // Age Limit Dropdown
            Consumer(
              builder: (context, ref, _) {
                final selectedAgeLimit = ref.watch(selectedAgeLimitProvider);
                return _buildDropdown(
                  'Age Limit',
                  ageLimits,
                  selectedAgeLimit,
                  (value) => ref.read(selectedAgeLimitProvider.notifier).state = value,
                );
              },
            ),
            
            // Languages Multi-Select
            Consumer(
              builder: (context, ref, _) {
                final selectedLanguages = ref.watch(selectedLanguagesProvider);
                return _buildMultiSelectDropdown(
                  'Languages',
                  languages,
                  selectedLanguages,
                  (newLanguages) => ref.read(selectedLanguagesProvider.notifier).state = newLanguages,
                );
              },
            ),
            
            // Date Selector
            Consumer(
              builder: (context, ref, _) {
                final selectedDate = ref.watch(eventDateProvider);
                return _buildSelector(
                  'Date', 
                  selectedDate, 
                  () => handlers.pickDate(context, ref), 
                  Icons.calendar_today
                );
              },
            ),
            
            // Time Selectors
            Row(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final startTime = ref.watch(startTimeProvider);
                      return _buildSelector(
                        'Start Time', 
                        startTime, 
                        () => handlers.pickStartTime(context, ref), 
                        Icons.access_time
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Expanded(
                //   child: Consumer(
                //     builder: (context, ref, _) {
                //       final endTime = ref.watch(endTimeProvider);
                //       return _buildSelector(
                //         'End Time (Optional)', 
                //         endTime, 
                //         () => handlers.pickEndTime(context, ref), 
                //         Icons.access_time
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
            
            // Image Section
            Consumer(
              builder: (context, ref, _) {
                final selectedImages = ref.watch(selectedImageProvider);
                return _buildImageSection(selectedImages, ref);
              },
            ),
            
            const SizedBox(height: 20),
            
            // Create Event Button
            ElevatedButton(
              style: _buttonStyle(),
              onPressed: () => handlers.createEvent(context, ref),
              child: const Text('Create Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: _inputDecoration(label),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter $label';
              if (label == 'Ticket Price' && double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelector(String label, DateTime? value, VoidCallback onTap, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: _selectorDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value != null
                        ? label.contains('Time')
                            ? DateFormat.jm().format(value)
                            : DateFormat('yyyy-MM-dd').format(value)
                        : label.contains('Optional') ? 'Optional' : 'Select $label',
                    style: TextStyle(color: Colors.deepPurple.shade700),
                  ),
                  Icon(icon, color: Colors.deepPurple.shade700),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: _inputDecoration(label),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'Please select $label' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectDropdown(String label, List<String> items, List<String> selectedValues, Function(List<String>) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(label),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) {
              if (value != null && !selectedValues.contains(value)) {
                onChanged(List.from(selectedValues)..add(value));
              }
            },
            hint: Text(selectedValues.isEmpty ? 'Select $label' : selectedValues.join(', ')),
            validator: (value) => selectedValues.isEmpty ? 'Please select at least one $label' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(List<File> selectedImages, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Images', style: _labelStyle()),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: _selectorDecoration(),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...selectedImages.map((image) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
                    )),
                GestureDetector(
                  onTap: () => handlers.pickImages(ref),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add_a_photo, color: Colors.deepPurple.shade700, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Styling Methods
  TextStyle _labelStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.deepPurple.shade700,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: 'Enter $label',
      filled: true,
      fillColor: Colors.deepPurple.shade50.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
      ),
    );
  }

  BoxDecoration _selectorDecoration() {
    return BoxDecoration(
      color: Colors.deepPurple.shade50.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple.shade600,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}