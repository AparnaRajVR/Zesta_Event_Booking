// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:z_organizer/providers/event_provider.dart';

// class SectionHeader extends StatelessWidget {
//   final String title;

//   const SectionHeader({Key? key, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 30,
//           width: 5,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple.shade700,
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.deepPurple.shade800,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AnimatedTextField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final int maxLines;
//   final IconData? icon;

//   const AnimatedTextField({
//     Key? key,
//     required this.label,
//     required this.controller,
//     this.maxLines = 1,
//     this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, opacity, child) {
//         return Opacity(
//           opacity: opacity,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - opacity)),
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 2, bottom: 8),
//                     child: Text(
//                       label, 
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600, 
//                         fontSize: 16, 
//                         color: Colors.deepPurple.shade800,
//                         letterSpacing: 0.3,
//                       )
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.deepPurple.shade100.withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: controller, 
//                       maxLines: maxLines, 
//                       style: TextStyle(color: Colors.deepPurple.shade900),
//                       decoration: InputDecoration(
//                         hintText: "Enter $label",
//                         hintStyle: TextStyle(color: Colors.deepPurple.shade300),
//                         filled: true,
//                         fillColor: Colors.white,
//                         prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple.shade500) : null,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.deepPurple.shade100, 
//                             width: 1
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.deepPurple.shade400, 
//                             width: 2
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class DateSelector extends ConsumerWidget {
//   final String label;
//   final DateTime? date;
//   final StateProvider<DateTime?> provider;

//   const DateSelector({
//     Key? key,
//     required this.label,
//     required this.date,
//     required this.provider,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 2, bottom: 8),
//             child: Text(
//               label, 
//               style: TextStyle(
//                 fontWeight: FontWeight.w600, 
//                 fontSize: 16, 
//                 color: Colors.deepPurple.shade800,
//                 letterSpacing: 0.3,
//               )
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.deepPurple.shade100, width: 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.deepPurple.shade100.withOpacity(0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: date ?? DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                     builder: (context, child) {
//                       return Theme(
//                         data: ThemeData.light().copyWith(
//                           colorScheme: ColorScheme.light(
//                             primary: Colors.deepPurple.shade600,
//                           ),
//                           dialogBackgroundColor: Colors.white,
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (pickedDate != null) {
//                     ref.read(provider.notifier).state = pickedDate;
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                   child: Row(
//                     children: [
//                       Icon(Icons.calendar_today, color: Colors.deepPurple.shade500),
//                       const SizedBox(width: 16),
//                       Text(
//                         date != null ? DateFormat('EEEE, MMM dd, yyyy').format(date) : "Select date",
//                         style: TextStyle(
//                           color: date != null ? Colors.deepPurple.shade900 : Colors.deepPurple.shade300,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple.shade300),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TimeSelector extends ConsumerWidget {
//   final String label;
//   final DateTime? time;
//   final StateProvider<DateTime?> provider;

//   const TimeSelector({
//     Key? key,
//     required this.label,
//     required this.time,
//     required this.provider,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 2, bottom: 8),
//             child: Text(
//               label, 
//               style: TextStyle(
//                 fontWeight: FontWeight.w600, 
//                 fontSize: 16, 
//                 color: Colors.deepPurple.shade800,
//                 letterSpacing: 0.3,
//               )
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.deepPurple.shade100, width: 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.deepPurple.shade100.withOpacity(0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: time != null 
//                       ? TimeOfDay(hour: time.hour, minute: time.minute) 
//                       : TimeOfDay.now(),
//                     builder: (context, child) {
//                       return Theme(
//                         data: ThemeData.light().copyWith(
//                           colorScheme: ColorScheme.light(
//                             primary: Colors.deepPurple.shade600,
//                           ),
//                           dialogBackgroundColor: Colors.white,
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (pickedTime != null) {
//                     ref.read(provider.notifier).state = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                   child: Row(
//                     children: [
//                       Icon(Icons.access_time, color: Colors.deepPurple.shade500),
//                       const SizedBox(width: 16),
//                       Text(
//                         time != null ? DateFormat.jm().format(time) : "Select time",
//                         style: TextStyle(
//                           color: time != null ? Colors.deepPurple.shade900 : Colors.deepPurple.shade300,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple.shade300),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class  final List<File> selectedImages;

//   const ImagePicker({Key? key, required this.selectedImages}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.deepPurple.shade100, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.deepPurple.shade100.withOpacity(0.15),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             alignment: WrapAlignment.start,
//             children: [
//               ...selectedImages.map((image) => Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 5,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         image, 
//                         width: 90, 
//                         height: 90, 
//                         fit: BoxFit.cover
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         final updatedImages = List<File>.from(selectedImages)..remove(image);
//                         ref.read(selectedImageProvider.notifier).state = updatedImages;
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 3,
//                               offset: const Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         padding: const EdgeInsets.all(4),
//                         child: Icon(Icons.close, size: 16, color: Colors.red.shade600),
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//               InkWell(
//                 borderRadius: BorderRadius.circular(12),
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
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.deepPurple.shade200,
//                       width: 1,
//                       style: BorderStyle.dashed,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.add_photo_alternate, 
//                         color: Colors.deepPurple.shade600,
//                         size: 30,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Add Images",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.deepPurple.shade700,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (selectedImages.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 12),
//               child: Text(
//                 "${selectedImages.length} ${selectedImages.length == 1 ? 'image' : 'images'} selected",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.deepPurple.shade700,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class CreateEventButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const CreateEventButton({Key? key, required this.onPressed}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       duration: const Duration(milliseconds: 400),
//       tween: Tween<double>(begin: 0.8, end: 1.0),
//       builder: (context, scale, child) {
//         return Transform.scale(
//           scale: scale,
//           child: Container(
//             height: 60,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.deepPurple.shade700,
//                   Colors.deepPurple.shade500,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.deepPurple.shade200.withOpacity(0.5),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               onPressed: onPressed,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.celebration, size: 22),
//                   const SizedBox(width: 10),
//                   const Text(
//                     "Create Event", 
//                     style: TextStyle(
//                       fontSize: 18, 
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }