import 'package:flutter/material.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';


class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      label: 'Email',
      hint: 'name@example.com',
      prefixIcon: const Icon(Icons.email_outlined, color: Colors.purple),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        return null;
      },
    );
  }
}



class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      label: 'Password',
      hint: 'Enter your password',
      isPassword: true,
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.purple),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

