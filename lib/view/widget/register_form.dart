
// import 'package:flutter/material.dart';
// import 'package:z_organizer/constant/color.dart';
// import 'package:z_organizer/view/widget/custom_feild.dart';

// class RegisterFormWidget extends StatelessWidget {
//     final TextEditingController nameController;
//   final TextEditingController emailController;
//   final TextEditingController phoneController;
//   final TextEditingController addressController;
//   final TextEditingController orgNameController;
//      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//    RegisterFormWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//            CustomTextFormField(
//             controller: nameController,
//             label: 'Full Name',
//             hint: 'Enter your full name',
//           ),
//            SizedBox(height: 16.0),
//            CustomTextFormField(
//             controller: emailController,
//             label: 'Email',
//             hint: 'Enter your email',
//           ),
//            SizedBox(height: 16.0),
//            CustomTextFormField(
//             controller: phoneController,
//             label: 'Phone Number',
//             hint: 'Enter your phone number',
//           ),
//            SizedBox(height: 16.0),
//           DropdownButtonFormField<String>(
//             decoration:  InputDecoration(
//               labelText: 'Organizer Type',
//               border: OutlineInputBorder(),
//             ),
//             items:  [
//               DropdownMenuItem(
//                 value: 'Type A',
//                 child: Text('Type A'),
//               ),
//               DropdownMenuItem(
//                 value: 'Type B',
//                 child: Text('Type B'),
//               ),
//               DropdownMenuItem(
//                 value: 'Type C',
//                 child: Text('Type C'),
//               ),
//             ],
//             onChanged: (value) {},
//           ),
//            SizedBox(height: 16.0),
           
//            CustomTextFormField(
//             controller: orgNameController,
//             label: 'Organization Name',
//             hint: 'Enter organization name',
//           ),
//            SizedBox(height: 16.0),
//            CustomTextFormField(
//             controller: addressController,
//             label: 'Organization Address',
//             hint: 'Enter organization address',
//           ),
//            SizedBox(height: 18.0),
//           ElevatedButton.icon(
//             onPressed: () {},
//             icon:  Icon(Icons.upload_file, color: Colors.white),
//             label:  Text(
//               'Upload Document',
//               style: TextStyle(color: Colors.white),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//             ),
//           ),
//            SizedBox(height: 17.5),
//           ElevatedButton(
//             onPressed: () {},
//             child:  Text(
//               'Register',
//               style: TextStyle(color: Colors.white),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';

class RegisterFormWidget extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            controller: emailController,
            label: 'Email',
            hint: 'Enter your email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            controller: phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Organizer Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Type A',
                child: Text('Type A'),
              ),
              DropdownMenuItem(
                value: 'Type B',
                child: Text('Type B'),
              ),
              DropdownMenuItem(
                value: 'Type C',
                child: Text('Type C'),
              ),
            ],
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an organizer type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            controller: orgNameController,
            label: 'Organization Name',
            hint: 'Enter organization name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Organization name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            controller: addressController,
            label: 'Organization Address',
            hint: 'Enter organization address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Organization address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 18.0),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle file upload logic
              }
            },
            icon: const Icon(Icons.upload_file, color: Colors.white),
            label: const Text(
              'Upload Document',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 17.5),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle registration logic
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
