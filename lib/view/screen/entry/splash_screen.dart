
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:z_organizer/view/screen/entry/login_screen.dart' show LoginPage, LoginScreen;

// import 'package:z_organizer/view/screen/entry/onboarding.dart';
// import 'package:z_organizer/view/screen/entry/signup.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
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

    
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
      // final user = ref.read(authStateProvider);
      
      // // Wait for the authentication state to resolve
      // await user.when(
      //   data: (user) {
      //     if (user == null) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => RegisterForm()),
      //       );
      //     } else {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => Dashboard()),
      //       );
      //     }
      //   },
      //   loading: () {
      //     // Optionally handle loading state
      //     print("Loading authentication state...");
      //   },
      //   error: (error, stack) {
      //     // Handle error state
      //     print("Error in auth state: $error");
      //   },
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: AnimatedScale(
            scale: _scale,
            duration: Duration(seconds: 1), 
            child: Image.asset('asset/logo.png'),
          ),
        ),
      ),
    );
  }
}
