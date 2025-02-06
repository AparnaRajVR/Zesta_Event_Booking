// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/user_model.dart';
// import '../../providers/auth_providers.dart';
// import '../authentication/service/auth_service.dart';


// class SignupViewModel extends StateNotifier<AsyncValue<UserModel?>> {
//   final AuthServices _authServices;

//   SignupViewModel(this._authServices) : super(const AsyncValue.data(null));

//   Future<String> signUp({
//     required String fullName,
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     state = const AsyncValue.loading();

//     try {
//       // Validate input
//       if (password != confirmPassword) {
//         return 'Passwords do not match';
//       }

//       if (password.length < 6) {
//         return 'Password must be at least 6 characters';
//       }

//       // Attempt signup
//       final result = await _authServices.signUp(
//         fullName: fullName,
//         email: email,
//         password: password,
//         confirmPassword: confirmPassword,
//       );

//       if (result == "SignUp successful") {
//         final user = UserModel(fullName: fullName, email: email);
//         state = AsyncValue.data(user);
//          // **Check email verification status**
//         // bool isVerified = await _authServices.isEmailVerified();
//         // if (!isVerified) {
//         //   // If not verified, send a verification email
//         //   await _authServices.sendVerificationEmail();
//         //   return 'Verification email sent. Please check your inbox.';
//         // }
//         return result;
//       } else {
//         state = const AsyncValue.data(null);
//         return result;
//       }
//     } catch (error) {
//       state = const AsyncValue.data(null);
//       return 'Signup failed: ${error.toString()}';
//     }
//   }
// }

// final signupViewModelProvider = StateNotifierProvider<SignupViewModel, AsyncValue<UserModel?>>((ref) {
//   final authServices = ref.watch(authServicesProvider);
//   return SignupViewModel(authServices);
// });
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../../providers/auth_providers.dart';
import '../authentication/service/auth_service.dart';

class SignupViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthServices _authServices;

  SignupViewModel(this._authServices) : super(const AsyncValue.data(null));

  // Function to handle sign-up
  Future<String> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading(); // Set loading state

    try {
      // Input validation
      if (password != confirmPassword) return 'Passwords do not match';
      if (password.length < 6) return 'Password must be at least 6 characters';

      // Call sign-up service
      final result = await _authServices.signUp(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result == "SignUp successful") {
        // If sign-up is successful, fetch user data from the service
        final userData = await _authServices.getUserDetails();
        
        if (userData != null) {
          // Create a UserModel instance using the fetched user data
          final user = UserModel(
            fullName: userData["fullName"] ?? "Unknown",
            email: userData["email"] ?? email,
          );

          state = AsyncValue.data(user); // Update state with user data
          return result; // Return success message
        } else {
          state = const AsyncValue.data(null);
          return "SignUp successful, but failed to fetch user details.";
        }
      } else {
        state = const AsyncValue.data(null);
        return result; // Return failure message
      }
    } catch (error) {
      state = const AsyncValue.data(null);
      return 'Signup failed: ${error.toString()}';
    }
  }
}

// Provider for the Signup ViewModel
final signupViewModelProvider = StateNotifierProvider<SignupViewModel, AsyncValue<UserModel?>>((ref) {
  final authServices = ref.watch(authServicesProvider); // Get the AuthServices provider
  return SignupViewModel(authServices); // Return an instance of SignupViewModel
});
