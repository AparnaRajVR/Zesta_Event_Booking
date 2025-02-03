import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'asset/images/logo.png',
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}