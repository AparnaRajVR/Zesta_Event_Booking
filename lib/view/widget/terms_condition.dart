
import 'package:flutter/material.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 8, 8, 8),
            height: 1.5,
          ),
          children: [
            TextSpan(text: 'By signing in or creating an account you agree with our '),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
