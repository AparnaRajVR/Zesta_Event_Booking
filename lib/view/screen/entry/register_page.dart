
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/view/widget/custom_appbar.dart';
import 'package:z_organizer/view/widget/register_form.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authServiceProvider);
    
    return Scaffold(
      appBar: CustomAppBar(title: 'Register Account'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.second, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: authRepository.getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text("Failed to load user details"));
            }

            final userData = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                child: GlassmorphicContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 2,
                  borderGradient: const LinearGradient(
                    colors: [Colors.white70, Colors.white10],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  linearGradient: const LinearGradient(
                    colors: [Colors.white24, Colors.white10],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.5),
                    child: RegisterFormWidget(
                      fullName: userData["fullName"] ?? "No Name",
                      email: userData["email"] ?? "No Email",
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
