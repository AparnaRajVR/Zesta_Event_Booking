import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../../providers/auth_providers.dart';
import '../authentication/service/auth_service.dart';


class SignupViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthServices _authServices;

  SignupViewModel(this._authServices) : super(const AsyncValue.data(null));

  Future<String> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Validate input
      if (password != confirmPassword) {
        return 'Passwords do not match';
      }

      if (password.length < 6) {
        return 'Password must be at least 6 characters';
      }

      // Attempt signup
      final result = await _authServices.signUp(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result == "SignUp successful") {
        final user = UserModel(fullName: fullName, email: email);
        state = AsyncValue.data(user);
         // **Check email verification status**
        // bool isVerified = await _authServices.isEmailVerified();
        // if (!isVerified) {
        //   // If not verified, send a verification email
        //   await _authServices.sendVerificationEmail();
        //   return 'Verification email sent. Please check your inbox.';
        // }
        return result;
      } else {
        state = const AsyncValue.data(null);
        return result;
      }
    } catch (error) {
      state = const AsyncValue.data(null);
      return 'Signup failed: ${error.toString()}';
    }
  }
}

final signupViewModelProvider = StateNotifierProvider<SignupViewModel, AsyncValue<UserModel?>>((ref) {
  final authServices = ref.watch(authServicesProvider);
  return SignupViewModel(authServices);
});