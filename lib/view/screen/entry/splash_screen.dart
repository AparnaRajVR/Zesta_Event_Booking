

import 'package:flutter/material.dart';
import 'package:z_organizer/view/widget/animation_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AnimatedSplashLogo()),
    );
  }
}
