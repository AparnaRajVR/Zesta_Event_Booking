


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/auth_providers.dart';
import 'package:z_organizer/services/auth_service.dart';
import '../model/user_model.dart';


class LoginViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;  // Fixed naming

  LoginViewModel(this._authService) : super(const AsyncValue.data(null));

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _authService.signInWithEmailAndPassword(  // Fixed method name
        email: email,
        password: password,
      );

      if (result == "Login successful") {
        // Fetch user details from Firestore after successful login
        final userDetails = await _authService.getUserDetails();
        
        if (userDetails != null) {
          final userModel = UserModel(
            fullName: userDetails['fullName'] ?? '',
            email: userDetails['email'] ?? email,
          );
          state = AsyncValue.data(userModel);
        } else {
          state = const AsyncValue.data(null);
        }
        return result;
      } else {
        state = const AsyncValue.data(null);
        return result;
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return 'Login failed: ${error.toString()}';
    }
  }
  Future<String?> getUserStatus() async {
  try {
    final userDetails = await _authService.getUserDetails();
    return userDetails?['status']; // assuming 'status' field exists in Firestore
  } catch (e) {
    return null;
  }
}
}



// Updated provider to use the correct name
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);  // Fixed provider name
  return LoginViewModel(authService);
});
