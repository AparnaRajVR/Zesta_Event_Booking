// import 'package:flutter/material.dart';
// import 'package:z_organizer/view/screen/entry/register_page.dart';
// import '../../../VIewmodel/signup_viewmodel.dart';

// class SignupButton extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   final SignupViewModel signupViewModel;
//   final TextEditingController nameController;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final TextEditingController confirmPasswordController;

//   const SignupButton(BuildContext context, {
//     super.key,
//     required this.formKey,
//     required this.signupViewModel,
//     required this.nameController,
//     required this.emailController,
//     required this.passwordController,
//     required this.confirmPasswordController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: () async {
//           if (formKey.currentState?.validate() == true) {
//             final result = await signupViewModel.signUp(
//               fullName: nameController.text.trim(),
//               email: emailController.text.trim(),
//               password: passwordController.text.trim(),
//               confirmPassword: confirmPasswordController.text.trim(),
//             );

//             if (result == "SignUp successful") {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("SignUp successful")),
//               );
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(result)),
//               );
//             }
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color.fromARGB(255, 107, 70, 193),
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text(
//           'Create Account',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

