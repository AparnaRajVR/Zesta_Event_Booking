

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:z_organizer/view/widget/custom_feild.dart';
// import 'package:z_organizer/viewmodel/image_upload_viewmodel.dart';

// class AddEventScreen extends ConsumerStatefulWidget {
//   @override
//   _AddEventScreenState createState() => _AddEventScreenState();
// }

// class _AddEventScreenState extends ConsumerState<AddEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _venueController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();

//   String? _selectedCategory;
//   String? _selectedOrganizer;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   File? _selectedImage;
//   String? _uploadedImageUrl;

//   // Date Picker
//   void _pickDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     setState(() {
//       _selectedDate = date;
//     });
//   }

//   // Time Picker
//   void _pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     setState(() {
//       _selectedTime = time;
//     });
//   }

//   // Image Picker and Upload
//   Future<void> _pickAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;

//     File imageFile = File(pickedFile.path);
//     setState(() {
//       _selectedImage = imageFile;
//     });

//     // Upload to Cloudinary
//     final uploadedUrl = await ref.read(imageUploadProvider.notifier).uploadImage(imageFile);
//     if (uploadedUrl != null) {
//       setState(() {
//         _uploadedImageUrl = uploadedUrl;
//       });
//     }
//   }

//   // Form Submission
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_uploadedImageUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please upload an event image")),
//         );
//         return;
//       }

//       final eventData = {
//         "name": _nameController.text,
//         "category": _selectedCategory,
//         "organizer": _selectedOrganizer,
//         "venue": _venueController.text,
//         "city": _cityController.text,
//         "price": _priceController.text,
//         "date": _selectedDate?.toLocal().toString(),
//         "time": _selectedTime?.format(context),
//         "imageUrl": _uploadedImageUrl,
//       };

//       debugPrint("Event Data: $eventData");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Event successfully added!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Event")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Event Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
//                 const SizedBox(height: 10),
//                 CustomTextFormField(
//                   controller: _nameController,
//                   label: "Event Name",
//                   hint: "Enter event name",
//                   prefixIcon: const Icon(Icons.event),
//                   validator: (value) => value!.isEmpty ? "Event name is required" : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextFormField(
//                         label: "Event Category",
//                         hint: "Select Category",
//                         isDropdown: true,
//                         dropdownItems: const [
//                           DropdownMenuItem(value: "Music", child: Text("Music")),
//                           DropdownMenuItem(value: "Sports", child: Text("Sports")),
//                         ],
//                         selectedValue: _selectedCategory,
//                         onChanged: (val) => setState(() => _selectedCategory = val),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: CustomTextFormField(
//                         label: "Organizer Type",
//                         hint: "Select Organizer",
//                         isDropdown: true,
//                         dropdownItems: const [
//                           DropdownMenuItem(value: "Individual", child: Text("Individual")),
//                           DropdownMenuItem(value: "Company", child: Text("Company")),
//                         ],
//                         selectedValue: _selectedOrganizer,
//                         onChanged: (val) => setState(() => _selectedOrganizer = val),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 CustomTextFormField(
//                   controller: _venueController,
//                   label: "Venue Address",
//                   hint: "Enter venue address",
//                   prefixIcon: const Icon(Icons.location_on),
//                   validator: (value) => value!.isEmpty ? "Venue is required" : null,
//                 ),
//                 const SizedBox(height: 12),
//                 CustomTextFormField(
//                   controller: _cityController,
//                   label: "City",
//                   hint: "Enter city",
//                   prefixIcon: const Icon(Icons.location_city),
//                 ),
//                 const SizedBox(height: 12),
//                 CustomTextFormField(
//                   controller: _priceController,
//                   label: "Price",
//                   hint: "Enter price",
//                   keyboardType: TextInputType.number,
//                   prefixIcon: const Icon(Icons.attach_money),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text("Date & Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: _pickDate,
//                         child: AbsorbPointer(
//                           child: CustomTextFormField(
//                             label: "Date",
//                             hint: _selectedDate == null ? "Select Date" : _selectedDate!.toLocal().toString().split(' ')[0],
//                             prefixIcon: const Icon(Icons.calendar_today),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: _pickTime,
//                         child: AbsorbPointer(
//                           child: CustomTextFormField(
//                             label: "Start Time",
//                             hint: _selectedTime == null ? "Start Time" : _selectedTime!.format(context),
//                             prefixIcon: const Icon(Icons.access_time),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Text("Event Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: _pickAndUploadImage,
//                   child: Container(
//                     height: 100,
//                     width: 100,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(10),
//                       image: _selectedImage != null
//                           ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
//                           : null,
//                     ),
//                     child: _selectedImage == null
//                         ? const Icon(Icons.add_a_photo, color: Colors.purple)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
//                   child: const Text("Publish Event"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';

// Providers for date and time selection
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final startTimeProvider = StateProvider<TimeOfDay?>((ref) => null);
final endTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

// Image picker provider
final selectedImageProvider = StateProvider<File?>((ref) => null);

class AddEventScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final selectedImage = ref.watch(selectedImageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Event Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
                const SizedBox(height: 10),
                CustomTextFormField(controller: _nameController, label: "Event Name", hint: "Enter event name", prefixIcon: const Icon(Icons.event)),
                const SizedBox(height: 12),
                CustomTextFormField(controller: _venueController, label: "Venue", hint: "Enter venue", prefixIcon: const Icon(Icons.location_on)),
                const SizedBox(height: 12),
                CustomTextFormField(controller: _cityController, label: "City", hint: "Enter city", prefixIcon: const Icon(Icons.location_city)),
                const SizedBox(height: 12),
                CustomTextFormField(controller: _priceController, label: "Price", hint: "Enter price", keyboardType: TextInputType.number, prefixIcon: const Icon(Icons.attach_money)),
                const SizedBox(height: 16),
                const Text("Date & Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          ref.read(selectedDateProvider.notifier).state = date;
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: "Date",
                            hint: selectedDate == null ? "Select Date" : selectedDate.toLocal().toString().split(' ')[0],
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          ref.read(startTimeProvider.notifier).state = time;
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: "Start Time",
                            hint: startTime == null ? "Start Time" : startTime.format(context),
                            prefixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          ref.read(endTimeProvider.notifier).state = time;
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: "End Time",
                            hint: endTime == null ? "End Time" : endTime.format(context),
                            prefixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Event Images", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      ref.read(selectedImageProvider.notifier).state = File(pickedFile.path);
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: selectedImage == null
                        ? const Icon(Icons.add_a_photo, color: Colors.purple)
                        : Image.file(selectedImage, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text("Cancel")),
                    ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), child: const Text("Publish Event")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
