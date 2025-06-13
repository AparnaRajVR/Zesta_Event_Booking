import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'asset/images/logo1.png',
          height: 280,
          width: 280,
        ),
      ),
    );
  }
}