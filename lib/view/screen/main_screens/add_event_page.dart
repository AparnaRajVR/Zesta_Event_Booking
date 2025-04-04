

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:z_organizer/providers/event_provider.dart';
// import 'package:z_organizer/services/event_service.dart';

// class AddEventScreen extends ConsumerWidget {
//   final TextEditingController eventNameController = TextEditingController();
//   final TextEditingController eventDescriptionController = TextEditingController();
//   final TextEditingController eventAddressController = TextEditingController();
//   final TextEditingController eventCityController = TextEditingController();

//   AddEventScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedImages = ref.watch(selectedImageProvider);
//     final selectedDate = ref.watch(eventDateProvider);
//     final startTime = ref.watch(startTimeProvider);
//     final endTime = ref.watch(endTimeProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           "Create New Event", 
//           style: TextStyle(
//             color: Colors.deepPurple.shade700, 
//             fontWeight: FontWeight.bold
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.deepPurple.shade700),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               Colors.deepPurple.shade50.withOpacity(0.3)
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildAnimatedTextField("Event Name", eventNameController),
//                 _buildAnimatedTextField("Event Description", eventDescriptionController, maxLines: 3),
//                 _buildAnimatedTextField("Event Address", eventAddressController),
//                 _buildAnimatedTextField("City", eventCityController),
//                 _buildDateSelector(context, ref, "Event Date", selectedDate, eventDateProvider),
//                 _buildTimeSelector(context, ref, "Start Time", startTime, startTimeProvider),
//                 _buildTimeSelector(context, ref, "End Time", endTime, endTimeProvider),
//                 _buildImagePicker(context, ref, selectedImages),
//                 const SizedBox(height: 20),

//                 // Create Event Button
//                 TweenAnimationBuilder(
//                   duration: const Duration(milliseconds: 300),
//                   tween: Tween<double>(begin: 0.8, end: 1.0),
//                   builder: (context, scale, child) {
//                     return Transform.scale(
//                       scale: scale,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple.shade600,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (selectedImages.isEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Please select at least one image")),
//                             );
//                             return;
//                           }

//                           final firebaseService = ref.read(firebaseServiceProvider);

//                           try {
//                             List<String> imageUrls = await firebaseService.uploadImages(selectedImages);
//                             await firebaseService.createEvent(
//                               name: eventNameController.text,
//                               description: eventDescriptionController.text,
//                               address: eventAddressController.text,
//                               city: eventCityController.text,
//                               date: selectedDate,
//                               startTime: startTime,
//                               endTime: endTime,
//                               imageUrls: imageUrls,
//                             );

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Event Created Successfully!")),
//                             );

//                             _clearFields(ref);
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Failed to create event: $e")),
//                             );
//                           }
//                         },
//                         child: const Text(
//                           "Create Event", 
//                           style: TextStyle(
//                             fontSize: 18, 
//                             fontWeight: FontWeight.bold
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedTextField(String label, TextEditingController controller, {int maxLines = 1}) {
//     return TweenAnimationBuilder(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, opacity, child) {
//         return Opacity(
//           opacity: opacity,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - opacity)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label, 
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold, 
//                     fontSize: 16, 
//                     color: Colors.deepPurple.shade700
//                   )
//                 ),
//                 TextField(
//                   controller: controller, 
//                   maxLines: maxLines, 
//                   decoration: InputDecoration(
//                     hintText: "Enter $label",
//                     filled: true,
//                     fillColor: Colors.deepPurple.shade50.withOpacity(0.3),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.deepPurple.shade200, 
//                         width: 2
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDateSelector(BuildContext context, WidgetRef ref, String label, DateTime? date, StateProvider<DateTime?> provider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label, 
//           style: TextStyle(
//             fontWeight: FontWeight.bold, 
//             fontSize: 16, 
//             color: Colors.deepPurple.shade700
//           )
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.deepPurple.shade50.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ListTile(
//             title: Text(
//               date != null ? DateFormat('yyyy-MM-dd').format(date) : "Pick a date",
//               style: TextStyle(color: Colors.deepPurple.shade700),
//             ),
//             trailing: Icon(Icons.calendar_today, color: Colors.deepPurple.shade700),
//             onTap: () async {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: date ?? DateTime.now(),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime(2100),
//                 builder: (context, child) {
//                   return Theme(
//                     data: ThemeData.light().copyWith(
//                       colorScheme: ColorScheme.light(
//                         primary: Colors.deepPurple.shade600,
//                       ),
//                     ),
//                     child: child!,
//                   );
//                 },
//               );
//               if (pickedDate != null) {
//                 ref.read(provider.notifier).state = pickedDate;
//               }
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildTimeSelector(BuildContext context, WidgetRef ref, String label, DateTime? time, StateProvider<DateTime?> provider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label, 
//           style: TextStyle(
//             fontWeight: FontWeight.bold, 
//             fontSize: 16, 
//             color: Colors.deepPurple.shade700
//           )
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.deepPurple.shade50.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ListTile(
//             title: Text(
//               time != null ? DateFormat.jm().format(time) : "Pick a time",
//               style: TextStyle(color: Colors.deepPurple.shade700),
//             ),
//             trailing: Icon(Icons.access_time, color: Colors.deepPurple.shade700),
//             onTap: () async {
//               TimeOfDay? pickedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//                 builder: (context, child) {
//                   return Theme(
//                     data: ThemeData.light().copyWith(
//                       colorScheme: ColorScheme.light(
//                         primary: Colors.deepPurple.shade600,
//                       ),
//                     ),
//                     child: child!,
//                   );
//                 },
//               );
//               if (pickedTime != null) {
//                 ref.read(provider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
//               }
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildImagePicker(BuildContext context, WidgetRef ref, List<File> selectedImages) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Event Images", 
//           style: TextStyle(
//             fontWeight: FontWeight.bold, 
//             fontSize: 16, 
//             color: Colors.deepPurple.shade700
//           )
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.deepPurple.shade50.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: const EdgeInsets.all(8),
//           child: Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             alignment: WrapAlignment.start,
//             children: [
//               ...selectedImages.map((image) => ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.file(
//                   image, 
//                   width: 80, 
//                   height: 80, 
//                   fit: BoxFit.cover
//                 ),
//               )),
//               InkWell(
//                 borderRadius: BorderRadius.circular(10),
//                 onTap: () async {
//                   final pickedFiles = await ImagePicker().pickMultiImage();
//                   if (pickedFiles.isNotEmpty) {
//                     ref.read(selectedImageProvider.notifier).state = [
//                       ...selectedImages,
//                       ...pickedFiles.map((file) => File(file.path))
//                     ];
//                   }
//                 },
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.shade100.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.add_a_photo, 
//                     color: Colors.deepPurple.shade700,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   void _clearFields(WidgetRef ref) {
//     eventNameController.clear();
//     eventDescriptionController.clear();
//     eventAddressController.clear();
//     eventCityController.clear();
    
//     ref.read(selectedImageProvider.notifier).state = [];
//     ref.read(eventDateProvider.notifier).state = null;
//     ref.read(startTimeProvider.notifier).state = null;
//     ref.read(endTimeProvider.notifier).state = null;
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:z_organizer/providers/event_provider.dart';
// import 'package:z_organizer/services/event_service.dart';

// class AddEventScreen extends ConsumerStatefulWidget {
//   const AddEventScreen({super.key});

//   @override
//   _AddEventScreenState createState() => _AddEventScreenState();
// }

// class _AddEventScreenState extends ConsumerState<AddEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _controllers = {
//     'name': TextEditingController(),
//     'description': TextEditingController(),
//     'address': TextEditingController(),
//     'city': TextEditingController(),
//   };

//   @override
//   void dispose() {
//     _controllers.forEach((_, controller) => controller.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedImages = ref.watch(selectedImageProvider);
//     final selectedDate = ref.watch(eventDateProvider);
//     final startTime = ref.watch(startTimeProvider);
//     final endTime = ref.watch(endTimeProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: Container(
//         decoration: _gradientDecoration(),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildTextField('Event Name', _controllers['name']!),
//                   _buildTextField('Description', _controllers['description']!, maxLines: 3),
//                   _buildTextField('Address', _controllers['address']!),
//                   _buildTextField('City', _controllers['city']!),
//                   _buildSelector('Date', selectedDate, _pickDate, Icons.calendar_today),
//                   _buildSelector('Start Time', startTime, _pickStartTime, Icons.access_time),
//                   _buildSelector('End Time', endTime, _pickEndTime, Icons.access_time),
//                   _buildImageSection(selectedImages),
//                   const SizedBox(height: 20),
//                   _buildCreateButton(selectedImages, selectedDate, startTime, endTime),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       title: Text(
//         'Create New Event',
//         style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold),
//       ),
//       centerTitle: true,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.deepPurple.shade700),
//         onPressed: () => Navigator.pop(context),
//       ),
//     );
//   }

//   BoxDecoration _gradientDecoration() {
//     return BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.white, Colors.deepPurple.shade50.withOpacity(0.3)],
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: _labelStyle()),
//           TextFormField(
//             controller: controller,
//             maxLines: maxLines,
//             decoration: _inputDecoration(label),
//             validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSelector(String label, DateTime? value, Function onTap, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: _labelStyle()),
//           GestureDetector(
//             onTap: () => onTap(),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//               decoration: _selectorDecoration(),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     value != null
//                         ? label.contains('Time')
//                             ? DateFormat.jm().format(value)
//                             : DateFormat('yyyy-MM-dd').format(value)
//                         : 'Select $label',
//                     style: TextStyle(color: Colors.deepPurple.shade700),
//                   ),
//                   Icon(icon, color: Colors.deepPurple.shade700),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageSection(List<File> selectedImages) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Event Images', style: _labelStyle()),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: _selectorDecoration(),
//             child: Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 ...selectedImages.map((image) => ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
//                     )),
//                 GestureDetector(
//                   onTap: _pickImages,
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple.shade100.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(Icons.add_a_photo, color: Colors.deepPurple.shade700, size: 30),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreateButton(List<File> images, DateTime? date, DateTime? start, DateTime? end) {
//     return ElevatedButton(
//       style: _buttonStyle(),
//       onPressed: () => _createEvent(images, date, start, end),
//       child: const Text('Create Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }

//   TextStyle _labelStyle() {
//     return TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//       color: Colors.deepPurple.shade700,
//     );
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       hintText: 'Enter $label',
//       filled: true,
//       fillColor: Colors.deepPurple.shade50.withOpacity(0.3),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
//       ),
//     );
//   }

//   BoxDecoration _selectorDecoration() {
//     return BoxDecoration(
//       color: Colors.deepPurple.shade50.withOpacity(0.3),
//       borderRadius: BorderRadius.circular(10),
//     );
//   }

//   ButtonStyle _buttonStyle() {
//     return ElevatedButton.styleFrom(
//       backgroundColor: Colors.deepPurple.shade600,
//       foregroundColor: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     );
//   }

//   Future<void> _pickDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       builder: (context, child) => Theme(
//         data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
//         child: child!,
//       ),
//     );
//     if (pickedDate != null) ref.read(eventDateProvider.notifier).state = pickedDate;
//   }

//   Future<void> _pickStartTime() async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) => Theme(
//         data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
//         child: child!,
//       ),
//     );
//     if (pickedTime != null) {
//       ref.read(startTimeProvider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
//     }
//   }

//   Future<void> _pickEndTime() async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) => Theme(
//         data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: Colors.deepPurple.shade600)),
//         child: child!,
//       ),
//     );
//     if (pickedTime != null) {
//       ref.read(endTimeProvider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
//     }
//   }

//   Future<void> _pickImages() async {
//     final pickedFiles = await ImagePicker().pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       ref.read(selectedImageProvider.notifier).state = [
//         ...ref.read(selectedImageProvider),
//         ...pickedFiles.map((file) => File(file.path)),
//       ];
//     }
//   }

//   Future<void> _createEvent(List<File> images, DateTime? date, DateTime? start, DateTime? end) async {
//     if (!_formKey.currentState!.validate() || images.isEmpty || date == null || start == null || end == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and select at least one image')),
//       );
//       return;
//     }

//     final firebaseService = ref.read(firebaseServiceProvider);
//     try {
//       final imageUrls = await firebaseService.uploadImages(images);
//       await firebaseService.createEvent(
//         name: _controllers['name']!.text,
//         description: _controllers['description']!.text,
//         address: _controllers['address']!.text,
//         city: _controllers['city']!.text,
//         date: date,
//         startTime: start,
//         endTime: end,
//         imageUrls: imageUrls,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Created Successfully!')));
//       _clearFields();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create event: $e')));
//     }
//   }

//   void _clearFields() {
//     _controllers.forEach((_, controller) => controller.clear());
//     ref.read(selectedImageProvider.notifier).state = [];
//     ref.read(eventDateProvider.notifier).state = null;
//     ref.read(startTimeProvider.notifier).state = null;
//     ref.read(endTimeProvider.notifier).state = null;
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/services/event_service.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'name': TextEditingController(),
    'description': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(selectedImageProvider);
    final selectedDate = ref.watch(eventDateProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
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
                  _buildTextField('Description', _controllers['description']!, maxLines: 3),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Address', _controllers['address']!)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('City', _controllers['city']!)),
                    ],
                  ),
                  _buildSelector('Date', selectedDate, _pickDate, Icons.calendar_today),
                  Row(
                    children: [
                      Expanded(child: _buildSelector('Start Time', startTime, _pickStartTime, Icons.access_time)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSelector('End Time', endTime, _pickEndTime, Icons.access_time)),
                    ],
                  ),
                  _buildImageSection(selectedImages),
                  const SizedBox(height: 20),
                  _buildCreateButton(selectedImages, selectedDate, startTime, endTime),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: _inputDecoration(label),
            validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSelector(String label, DateTime? value, Function onTap, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          GestureDetector(
            onTap: () => onTap(),
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
                        : 'Select $label',
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

  Widget _buildImageSection(List<File> selectedImages) {
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
                  onTap: _pickImages,
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

  Widget _buildCreateButton(List<File> images, DateTime? date, DateTime? start, DateTime? end) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _createEvent(images, date, start, end),
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

  Future<void> _pickDate() async {
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

  Future<void> _pickStartTime() async {
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

  Future<void> _pickEndTime() async {
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

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      ref.read(selectedImageProvider.notifier).state = [
        ...ref.read(selectedImageProvider),
        ...pickedFiles.map((file) => File(file.path)),
      ];
    }
  }

  Future<void> _createEvent(List<File> images, DateTime? date, DateTime? start, DateTime? end) async {
    if (!_formKey.currentState!.validate() || images.isEmpty || date == null || start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select at least one image')),
      );
      return;
    }

    final firebaseService = ref.read(firebaseServiceProvider);
    try {
      final imageUrls = await firebaseService.uploadImages(images);
      await firebaseService.createEvent(
        name: _controllers['name']!.text,
        description: _controllers['description']!.text,
        address: _controllers['address']!.text,
        city: _controllers['city']!.text,
        date: date,
        startTime: start,
        endTime: end,
        imageUrls: imageUrls,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Created Successfully!')));
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create event: $e')));
    }
  }

  void _clearFields() {
    _controllers.forEach((_, controller) => controller.clear());
    ref.read(selectedImageProvider.notifier).state = [];
    ref.read(eventDateProvider.notifier).state = null;
    ref.read(startTimeProvider.notifier).state = null;
    ref.read(endTimeProvider.notifier).state = null;
  }
}