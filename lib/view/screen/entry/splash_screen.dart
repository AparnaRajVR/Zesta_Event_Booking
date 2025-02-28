
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/view/screen/entry/dashboard_page.dart';
import 'package:z_organizer/view/screen/entry/login_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    authState.when(
      data: (user) {
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => user == null ? LoginPage() : Dashboard(),
            ),
          );
        });
      },
      loading: () {
        print("Loading authentication state...");
      },
      error: (error, stack) {
        print("Error in auth state: $error");
      },
    );

    return Scaffold(
      body: Center(
        child: AnimatedSplashLogo(),
      ),
    );
  }
}

// Animated Logo Widget
class AnimatedSplashLogo extends StatefulWidget {
  @override
  _AnimatedSplashLogoState createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<AnimatedSplashLogo> {
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(seconds: 1),
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(seconds: 1),
        child: Image.asset('asset/logo.png'),
      ),
    );
  }
}
