
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/entry/login_screen.dart';

import '../../../VIewmodel/onbaording_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingViewModel viewModel = OnboardingViewModel();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = viewModel.getPages(); 

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
          MaterialPageRoute(builder: (context) =>LoginPage()),
        ),
        onSkip: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>LoginPage()),
        ),
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(color: AppColors.primary),
        ),
        next: const Icon(Icons.arrow_forward, color: AppColors.primary),
        done: const Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        dotsDecorator: DotsDecorator(
          activeColor: AppColors.primary,
          size: const Size(10.0, 10.0),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: AppColors.textlight,
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors.textdark,
      ),
      pageColor: AppColors.textlight,
      imagePadding: EdgeInsets.all(40),
    );
  }
}
