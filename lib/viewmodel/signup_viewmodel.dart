
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/services/auth_service.dart';
import '../model/user_model.dart';


class SignupViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  SignupViewModel(this._authService) : super(const AsyncValue.data(null));

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
      final result = await _authService.createUserWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result == "SignUp successful") {
        // If sign-up is successful, fetch user data from the service
        final userData = await _authService.getUserDetails();
        
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
  final authServices = ref.watch(authServiceProvider); 
  return SignupViewModel(authServices);
});
