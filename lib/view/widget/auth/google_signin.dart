
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/providers/auth_providers.dart';
// import 'package:z_organizer/view/screen/entry/register_page.dart';
// import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';

// class GoogleAuthButton extends ConsumerWidget {
//   final bool isSignUp; 

//   const GoogleAuthButton({super.key, required this.isSignUp});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//       onTap: () async {
//   final authService = ref.read(authServiceProvider);
//   final message = await authService.signInWithGoogle();

//   // Show feedback message
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message)),
//   );

//   // Navigate after successful sign-in
//   if (message == "Google Sign-In successful") {
//     if (isSignUp) {
//       Navigator.pushReplacement(context,
//          MaterialPageRoute(
//           builder: (context) => RegisterScreen(), 
//         ),
//       );
//     } else {
//       Navigator.pushReplacement(context,
//          MaterialPageRoute(
//           builder: (context) => Dashboard(), 
//         ),
//       );
//     }
//   }
// },

//       child: Container(
//         width: double.infinity,
//         height: 56,
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 245, 236, 236),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.white),
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(255, 228, 216, 216),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'asset/images/google_icon.png',
//               height: 24,
//               width: 24,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isSignUp ? 'Sign up with Google' : 'Continue with Google',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/view/screen/entry/register_page.dart';
import 'package:z_organizer/view/screen/entry/verification_status.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';

class GoogleAuthButton extends ConsumerWidget {
  final bool isSignUp;

  const GoogleAuthButton({super.key, required this.isSignUp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final authService = ref.read(authServiceProvider);
        final message = await authService.signInWithGoogle();

        // Show feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (message == "Google Sign-In successful") {
          // 🔹 Check user registration & verification status
          final userDetails = await authService.getUserDetailsFromSubcollection();
          
          if (userDetails.isEmpty) {
            // ✅ New user -> Go to Register Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          } else {
            final isVerified = userDetails.first['status'] == 'approved';

            if (isVerified) {
              // ✅ Verified user -> Go to Dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            } else {
              // 🚧 Not verified -> Go to Success Page (Pending Approval)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SuccessPage()),
              );
            }
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 236, 236),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 228, 216, 216),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/images/google_icon.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            Text(
              isSignUp ? 'Sign up with Google' : 'Continue with Google',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
