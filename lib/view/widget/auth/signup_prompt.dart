
import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  final VoidCallback onTap;
  const SignUpPrompt({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Color.fromARGB(255, 19, 18, 18),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 19, 18, 18),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}