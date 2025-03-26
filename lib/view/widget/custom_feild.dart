


import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final bool isPassword;
  final bool isDropdown;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final double? height;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final void Function(String?)? onChanged;
  final String? selectedValue;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isDropdown = false,
    this.validator,
    this.prefixIcon,
    this.height,
    this.dropdownItems,
    this.onChanged,
    this.selectedValue,
    this.keyboardType,
  });

  InputDecoration getInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6B46C1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isDropdown
            ? DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: getInputDecoration(context), 
                items: dropdownItems,
                onChanged: onChanged,
                validator: validator,
              )
            : TextFormField(
                controller: controller,
                obscureText: isPassword,
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(fontSize: 16),
                keyboardType: keyboardType,
                onChanged: onChanged,
                decoration: getInputDecoration(context), 
              ),
      ],
    );
  }
}
