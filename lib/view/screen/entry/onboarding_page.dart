
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:z_organizer/view/screen/entry/signup_page.dart' show SignupPage, SignupScreen;

import '../../../VIewmodel/onbaording_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingViewModel viewModel = OnboardingViewModel();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = viewModel.getPages(); // Fetch data via ViewModel

    return Scaffold(
      body: IntroductionScreen(
        pages: pages.map((page) {
          return PageViewModel(
            title: page.title,
            body: page.body,
            image: Center(
              child: Image.asset(page.imagePath, height: 250),
            ),
            decoration: _pageDecoration(),
          );
        }).toList(),
        onDone: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>SignupPage()),
        ),
        onSkip: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>SignupPage()),
        ),
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(color: Colors.purpleAccent),
        ),
        next: const Icon(Icons.arrow_forward, color: Colors.purpleAccent),
        done: const Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.purpleAccent),
        ),
        dotsDecorator: DotsDecorator(
          activeColor: Colors.purpleAccent,
          size: const Size(10.0, 10.0),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: Colors.black,
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.all(40),
    );
  }
}
