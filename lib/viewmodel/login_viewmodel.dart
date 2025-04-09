// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/user_model.dart';
// import '../providers/auth_providers.dart';
// import '../authentication/service/auth_service.dart';


// class LoginViewModel extends StateNotifier<AsyncValue<UserModel?>> {
//   final AuthService _authServices;

//   LoginViewModel(this._authServices) : super(const AsyncValue.data(null));

//   Future<String> signIn({
//     required String email,
//     required String password,
//   }) async {
//     state = const AsyncValue.loading();

//     try {
//       final result = await _authServices.signIn(
//         email: email,
//         password: password,
//       );

//       if (result == "Login successful") {
//         // Assuming you want to create a UserModel after successful login
//         // You might need to fetch full name from your backend or use a placeholder
//         final userModel = UserModel(
//           fullName: '', // Fetch or use a placeholder
//           email: email,
//         );
//         state = AsyncValue.data(userModel);
//         return result;
//       } else {
//         state = const AsyncValue.data(null);
//         return result;
//       }
//     } catch (error) {
//       state = const AsyncValue.data(null);
//       return 'Login failed: ${error.toString()}';
//     }
//   }
// }

// final loginViewModelProvider = StateNotifierProvider<LoginViewModel, AsyncValue<UserModel?>>((ref) {
//   final authServices = ref.watch(authServicesProvider);
//   return LoginViewModel(authServices);
// });


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
}

// Updated provider to use the correct name
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);  // Fixed provider name
  return LoginViewModel(authService);
});
