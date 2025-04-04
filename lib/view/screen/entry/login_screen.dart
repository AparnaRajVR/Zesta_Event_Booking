
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/screen/entry/signup_page.dart';
import 'package:z_organizer/view/widget/divider_widget.dart';
import 'package:z_organizer/view/widget/auth/feild_widget.dart';
import 'package:z_organizer/view/widget/glass_container.dart';
import 'package:z_organizer/view/widget/auth/google_signin.dart';
import 'package:z_organizer/view/widget/auth/signin_button.dart';
import 'package:z_organizer/view/widget/auth/signup_prompt.dart';
import 'package:z_organizer/view/widget/terms_condition.dart';
import '../../../VIewmodel/login_viewmodel.dart';
import '../../widget/logo_widget.dart';// 

class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
    const backgroundColor = Color.fromARGB(255, 178, 171, 192);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassEffect( 
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LogoWidget(), 
                      const SizedBox(height: 32),
                      const GoogleAuthButton(isSignUp: false), 
                      const SizedBox(height: 24),
                      const DividerWithText(), 
                      const SizedBox(height: 24),
                      EmailField(controller: emailController), 
                      const SizedBox(height: 16),
                      PasswordField(controller: passwordController), 
                      const SizedBox(height: 24),
                      SignInButton(
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: _formKey,
                        loginViewModel: loginViewModel,
                      ), 
                      const SizedBox(height: 24),
                      SignUpPrompt(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                      ), 
                      const SizedBox(height: 16),
                      const TermsAndConditionsText(), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
