import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/entry/register_page.dart';
import 'package:z_organizer/view/screen/main_screens/dashboard_page.dart';
import 'package:z_organizer/viewmodel/login_viewmodel.dart';


class SignInButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final LoginViewModel loginViewModel;

  const SignInButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.loginViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
  if (formKey.currentState?.validate() == true) {
    final result = await loginViewModel.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result == "Login successful") {
      final status = await loginViewModel.getUserStatus();

      if (status == "approved") {
        // User is already registered and approved, go to Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        // Not registered or not approved, go to RegisterScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }
},

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textlight,
          ),
        ),
      ),
    );
  }
}
