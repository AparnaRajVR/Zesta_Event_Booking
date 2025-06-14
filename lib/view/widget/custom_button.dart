
import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';

class CustomButton extends StatelessWidget {
  final dynamic text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;
  

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textlight),
      ),
    );
  }
}
