


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/view/screen/entry/login_screen.dart';
import 'package:z_organizer/view/screen/entry/onboarding_page.dart';
import 'package:z_organizer/view/screen/entry/splash_screen.dart';
import 'package:z_organizer/view/screen/entry/verification_status.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const SplashScreen(),
      error: (error, _) => Scaffold(body: Center(child: Text("Error: $error"))),
      data: (user) {
        if (user == null) {
          return FutureBuilder<bool>(
            future: checkIfNewUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SplashScreen();
              return snapshot.data! ?  OnboardingScreen() : LoginPage();
            },
          );
        } else {
          return FutureBuilder<String?>(
            future: getUserStatus(user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SplashScreen();
              if (snapshot.data == "approved") {
                return const Dashboard();
              } else if (snapshot.data == "pending") {
                return const SuccessPage();
              }
              return Scaffold(body: Center(child: Text("Unknown status")));
            },
          );
        }
      },
    );
  }


  Future<bool> checkIfNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool isNew = prefs.getBool("isNewUser") ?? true;
    if (isNew) {
      await prefs.setBool("isNewUser", false); 
    }
    return isNew;
  }

  /// **Get user verification status from Firestore**
  Future<String?> getUserStatus(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.exists ? doc["status"] : null;
  }
}
