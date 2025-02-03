
 

//   import 'package:flutter/material.dart';
// import 'package:z_organizer/view/widget/custom_feild.dart';

// Widget SignupForm() {
//     final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//     final TextEditingController confirmPasswordController = TextEditingController();

//     return Column(
//       children: [
//         CustomTextFormField(
//           controller: nameController,
//           label: 'Full Name',
//           hint: 'Enter your full name',
//           prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Full name is required';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         CustomTextFormField(
//           controller: emailController,
//           label: 'Email Address',
//           hint: 'name@example.com',
//           prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Email is required';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         CustomTextFormField(
//           controller: passwordController,
//           label: 'Password',
//           hint: 'Create a password',
//           isPassword: true,
//           prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Password is required';
//             }
//             if (value.length < 6) {
//               return 'Password must be at least 6 characters';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         CustomTextFormField(
//           controller: confirmPasswordController,
//           label: 'Confirm Password',
//           hint: 'Re-enter your password',
//           isPassword: true,
//           prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please confirm your password';
//             }
//             if (value != passwordController.text) {
//               return 'Passwords do not match';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
