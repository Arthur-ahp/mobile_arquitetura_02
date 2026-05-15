import 'package:flutter/foundation.dart';
import 'package:product_app/core/session/session_controller.dart';
import 'package:product_app/domain/entities/auth_user.dart';
import 'package:product_app/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel {
  final AuthRepository repository;

  final ValueNotifier<AuthState> state = ValueNotifier(const AuthState());

  AuthViewModel(this.repository);

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      final user = await repository.login(
        username: username,
        password: password,
      );
      SessionController.instance.login(user);
      state.value = state.value.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loadCurrentUser() async {
    final sessionUser = SessionController.instance.user;
    final token = sessionUser?.accessToken;

    if (sessionUser == null || token == null || token.isEmpty) {
      return false;
    }

    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      final currentUser = await repository.getCurrentUser(token);
      final user = _mergeTokens(currentUser, sessionUser);
      SessionController.instance.login(user);
      state.value = state.value.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void logout() {
    SessionController.instance.logout();
    state.value = const AuthState();
  }

  AuthUser _mergeTokens(AuthUser currentUser, AuthUser sessionUser) {
    return currentUser.copyWith(
      accessToken: currentUser.accessToken.isNotEmpty
          ? currentUser.accessToken
          : sessionUser.accessToken,
      refreshToken: currentUser.refreshToken.isNotEmpty
          ? currentUser.refreshToken
          : sessionUser.refreshToken,
    );
  }
}
