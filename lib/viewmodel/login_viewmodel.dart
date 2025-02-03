import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../providers/auth_providers.dart';
import '../authentication/service/auth_service.dart';


class LoginViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthServices _authServices;

  LoginViewModel(this._authServices) : super(const AsyncValue.data(null));

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _authServices.signIn(
        email: email,
        password: password,
      );

      if (result == "Login successful") {
        // Assuming you want to create a UserModel after successful login
        // You might need to fetch full name from your backend or use a placeholder
        final userModel = UserModel(
          fullName: '', // Fetch or use a placeholder
          email: email,
        );
        state = AsyncValue.data(userModel);
        return result;
      } else {
        state = const AsyncValue.data(null);
        return result;
      }
    } catch (error) {
      state = const AsyncValue.data(null);
      return 'Login failed: ${error.toString()}';
    }
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, AsyncValue<UserModel?>>((ref) {
  final authServices = ref.watch(authServicesProvider);
  return LoginViewModel(authServices);
});