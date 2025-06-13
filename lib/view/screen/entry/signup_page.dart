

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/entry/register_page.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
import 'package:z_organizer/view/widget/divider_widget.dart';
import 'package:z_organizer/view/widget/auth/google_signin.dart';
import 'package:z_organizer/view/widget/logo_widget.dart';
import 'package:z_organizer/view/widget/terms_condition.dart';
import 'package:z_organizer/viewmodel/signup_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signupViewModel = ref.watch(signupViewModelProvider.notifier);
    // const primaryPurple = Color(0xFF6B46C1);

    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.textlight,
                 AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main  glass container
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 249, 249).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.textlight
                          .withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LogoWidget(),
                            const SizedBox(height: 24),
                            GoogleAuthButton(isSignUp: true),
                            const SizedBox(height: 24),
                            DividerWithText(),
                            const SizedBox(height: 24),
                            SignupForm(),
                            const SizedBox(height: 24),
                            _buildSignupButton(context, signupViewModel),
                            const SizedBox(height: 24),
                            TermsAndConditionsText(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 



 

  Widget SignupForm() {
    return Column(
      children: [
        CustomTextFormField(
          controller: nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.textlight,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: emailController,
          label: 'Email Address',
          hint: 'name@example.com',
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textlight,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: passwordController,
          label: 'Password',
          hint: 'Create a password',
          isPassword: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textlight,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          isPassword: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textlight,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context, SignupViewModel signupViewModel) {
    // const primaryPurple = Color(0xFF6B46C1);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            final result = await signupViewModel.signUp(
              fullName: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              confirmPassword: confirmPasswordController.text.trim(),
            );

            // Handle the result
            if (result == "SignUp successful") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("SignUp successful")),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(
               
              )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textlight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(160, 0, 0, 0),
            
          ),
        ),
      ),
    );
  }

}