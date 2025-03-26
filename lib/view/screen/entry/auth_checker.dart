import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/screen/entry/splash_screen.dart';
import 'package:z_organizer/view/screen/entry/login_screen.dart';
import 'package:z_organizer/view/screen/entry/verification_status.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';
import 'package:z_organizer/providers/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AuthChecker(), // ✅ Listen to Firebase Auth changes
    );
  }
}

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const SplashScreen(), // Show splash while checking auth
      error: (error, _) => Scaffold(body: Center(child: Text("Error: $error"))),
      data: (user) {
        if (user == null) {
          return  LoginPage(); // 🚀 User not logged in → LoginPage
        } else {
          return FutureBuilder<String?>(
            future: getUserStatus(user.uid), // Check Firestore for approval
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SplashScreen(); // Show splash while waiting
              }
              if (snapshot.data == "approved") {
                return const Dashboard(); // ✅ Approved → Dashboard
              } else {
                return const SuccessPage(); // ⏳ Pending approval → SuccessPage
              }
            },
          );
        }
      },
    );
  }

  Future<String?> getUserStatus(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.exists ? doc["status"] : null;
  }
}
