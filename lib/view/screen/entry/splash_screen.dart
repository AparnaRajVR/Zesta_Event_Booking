
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/providers/auth_providers.dart';
// import 'package:z_organizer/view/screen/entry/login_screen.dart';
// import 'package:z_organizer/view/screen/entry/verification_status.dart';
// import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';
// import 'package:z_organizer/view/widget/animation_logo.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SplashScreen extends ConsumerWidget {
//   const SplashScreen({super.key});

//   Future<String?> getUserStatus(String uid) async {
//     try {
//       final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
//       if (doc.exists) {
//         return doc["status"];
//       }
//       return null;
//     } catch (e) {
//       log("Error fetching user status: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);

//     authState.when(
//       data: (user) async {
//         if (user == null) {
//           // User is not logged in, navigate to Login Page
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         } else {
//           // User is logged in, check Firestore for approval status
//           String? status = await getUserStatus(user.uid);
//           if (status == "approved") {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => Dashboard()),
//             );
//           } else {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => SuccessPage()),
//             );
//           }
//         }
//       },
//       loading: () {
//         log("Loading authentication state...");
//       },
//       error: (error, stack) {
//         log("Error in auth state: $error");
//       },
//     );

//     return Scaffold(
//       body: Center(
//         child: AnimatedSplashLogo(),
//       ),
//     );
//   }
// }


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
