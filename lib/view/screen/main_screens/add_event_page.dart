import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/services/event_service.dart';

class AddEventScreen extends ConsumerWidget {
  AddEventScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  // Static controllers to persist across rebuilds
  static final _controllers = {
    'name': TextEditingController(),
    'organizerName': TextEditingController(),
    'description': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'duration': TextEditingController(),
    'ticketPrice': TextEditingController(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hardcoded options for age limits and languages
    final List<String> _ageLimits = ['All Ages', '13+', '18+', '21+'];
    final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: _gradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField('Event Name', _controllers['name']!),
                  _buildTextField('Organizer Name', _controllers['organizerName']!),
                  _buildTextField('Description', _controllers['description']!, maxLines: 3),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Address', _controllers['address']!)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('City', _controllers['city']!)),
                    ],
                  ),
                  _buildTextField('Duration', _controllers['duration']!),
                  _buildTextField('Ticket Price', _controllers['ticketPrice']!, keyboardType: TextInputType.number),
                  // Dynamic category dropdown
                  Consumer(
                    builder: (context, ref, _) {
                      return ref.watch(eventCategoriesProvider).when(
                            data: (categories) => categories.isEmpty
                                ? const Text('No categories available', style: TextStyle(color: Colors.red))
                                : _buildDropdown(
                                    'Category',
                                    categories.map((cat) => cat['name'] as String).toList(),
                                    categories.firstWhere(
                                      (cat) => cat['id'] == ref.watch(selectedCategoryIdProvider),
                                      orElse: () => {'id': null, 'name': null},
                                    )['name'],
                                    (value) {
                                      final selected = categories.firstWhere((cat) => cat['name'] == value);
                                      ref.read(selectedCategoryIdProvider.notifier).state = selected['id'] as String;
                                    },
                                  ),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => Text('Failed to load categories: $error', style: const TextStyle(color: Colors.red)),
                          );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedAgeLimit = ref.watch(selectedAgeLimitProvider);
                      return _buildDropdown(
                        'Age Limit',
                        _ageLimits,
                        selectedAgeLimit,
                        (value) => ref.read(selectedAgeLimitProvider.notifier).state = value,
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedLanguages = ref.watch(selectedLanguagesProvider);
                      return _buildMultiSelectDropdown(
                        'Languages',
                        _languages,
                        selectedLanguages,
                        (newLanguages) => ref.read(selectedLanguagesProvider.notifier).state = newLanguages,
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedDate = ref.watch(eventDateProvider);
                      return _buildSelector('Date', selectedDate, () => _pickDate(context, ref), Icons.calendar_today);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final startTime = ref.watch(startTimeProvider);
                            return _buildSelector('Start Time', startTime, () => _pickStartTime(context, ref), Icons.access_time);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final endTime = ref.watch(endTimeProvider);
                            return _buildSelector('End Time (Optional)', endTime, () => _pickEndTime(context, ref), Icons.access_time);
                          },
                        ),
                      ),
                    ],
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedImages = ref.watch(selectedImageProvider);
                      return _buildImageSection(selectedImages, ref);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildCreateButton(
                    ref.watch(selectedImageProvider),
                    ref.watch(eventDateProvider),
                    ref.watch(startTimeProvider),
                    ref.watch(endTimeProvider),
                    ref,
                    _controllers,
                    context,
                    ref.watch(selectedCategoryIdProvider),
                    ref.watch(selectedAgeLimitProvider),
                    ref.watch(selectedLanguagesProvider),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Create New Event',
        style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.deepPurple.shade700),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  BoxDecoration _gradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.deepPurple.shade50.withOpacity(0.3)],
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
                  onTap: () => _pickImages(ref),
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

  Widget _buildCreateButton(
    List<File> images,
    DateTime? date,
    DateTime? start,
    DateTime? end,
    WidgetRef ref,
    Map<String, TextEditingController> controllers,
    BuildContext context,
    String? selectedCategoryId,
    String? selectedAgeLimit,
    List<String> selectedLanguages,
  ) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _createEvent(
        images,
        date,
        start,
        end,
        ref,
        controllers,
        context,
        selectedCategoryId,
        selectedAgeLimit,
        selectedLanguages,
      ),
      child: const Text('Create Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

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

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
        child: child!,
      ),
    );
    if (pickedDate != null) ref.read(eventDateProvider.notifier).state = pickedDate;
  }

  Future<void> _pickStartTime(BuildContext context, WidgetRef ref) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
        child: child!,
      ),
    );
    if (pickedTime != null) {
      ref.read(startTimeProvider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
    }
  }

  Future<void> _pickEndTime(BuildContext context, WidgetRef ref) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
        child: child!,
      ),
    );
    if (pickedTime != null) {
      ref.read(endTimeProvider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
    }
  }

  Future<void> _pickImages(WidgetRef ref) async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      ref.read(selectedImageProvider.notifier).state = [
        ...ref.read(selectedImageProvider),
        ...pickedFiles.map((file) => File(file.path)),
      ];
    }
  }

  Future<void> _createEvent(
    List<File> images,
    DateTime? date,
    DateTime? start,
    DateTime? end,
    WidgetRef ref,
    Map<String, TextEditingController> controllers,
    BuildContext context,
    String? selectedCategoryId,
    String? selectedAgeLimit,
    List<String> selectedLanguages,
  ) async {
    final formState = _formKey.currentState;
    if (!formState!.validate() ||
        images.isEmpty ||
        date == null ||
        start == null ||
        selectedCategoryId == null ||
        selectedAgeLimit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields and select at least one image')),
      );
      return;
    }

    final firebaseService = ref.read(firebaseServiceProvider);
    try {
      final imageUrls = await firebaseService.uploadImages(images);
      await firebaseService.createEvent(
        name: controllers['name']!.text,
        organizerName: controllers['organizerName']!.text,
        description: controllers['description']!.text,
        address: controllers['address']!.text,
        city: controllers['city']!.text,
        categoryId: selectedCategoryId,
        duration: controllers['duration']!.text,
        ageLimit: [selectedAgeLimit],
        languages: selectedLanguages.isNotEmpty ? selectedLanguages : ['English'],
        date: date,
        startTime: start,
        endTime: end,
        imageUrls: imageUrls,
        ticketPrice: double.parse(controllers['ticketPrice']!.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Created Successfully!')));
      _clearFields(ref, controllers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create event: $e')));
    }
  }

  void _clearFields(WidgetRef ref, Map<String, TextEditingController> controllers) {
    controllers.forEach((_, controller) => controller.clear());
    ref.read(selectedImageProvider.notifier).state = [];
    ref.read(eventDateProvider.notifier).state = null;
    ref.read(startTimeProvider.notifier).state = null;
    ref.read(endTimeProvider.notifier).state = null;
    ref.read(selectedCategoryIdProvider.notifier).state = null;
    ref.read(selectedAgeLimitProvider.notifier).state = null;
    ref.read(selectedLanguagesProvider.notifier).state = [];
  }
}