
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';

final approvalStatusProvider = StreamProvider.autoDispose<bool>((ref) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users') 
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        print("Snapshot data: ${snapshot.data()}"); 
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          return data['status'] == 'approved';
        }
        return false;
      });
});

class SuccessPage extends ConsumerWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalStatus = ref.watch(approvalStatusProvider);

    return approvalStatus.when(
      data: (isApproved) {
        if (isApproved) {
          // Navigate to Dashboard when approved
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  Dashboard()),
            );
          });
        }

        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Registration Successful',
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 120, color: AppColors.lightText,),
                  const SizedBox(height: 30),
                  Text(
                    'Your registration was successful!',
                    style: TextStyle(
                      color: AppColors.lightText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please note, your account is pending verification. '
                    'Once verified by the admin, you will gain access to the home page.',
                    style: TextStyle(
                      color: AppColors.lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                // if (!isApproved) {
                //   const CircularProgressIndicator(color: Colors.white); // Show loading indicator
                // }
              ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white), // Show loading screen initially
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
