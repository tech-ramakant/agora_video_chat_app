
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_string.dart';
import '../../domain/entities/user_token.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final String? error;
  final UserToken? token;

  const AuthState({this.loading = false, this.error, this.token});

  AuthState copyWith({bool? loading, String? error, UserToken? token}) =>
      AuthState(
        loading: loading ?? this.loading,
        error: error,
        token: token ?? this.token,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;
  AuthNotifier(this.repo) : super(const AuthState());

  Future<void> login(String email, String password) async {

    if (email.isEmpty ) {
      state = state.copyWith(error: AppString.msg_enter_your_email);
      return;
    }

    if (password.isEmpty) {
      state = state.copyWith(error: AppString.msg_enter_your_password);
      return;
    }

    state = state.copyWith(loading: true, error: null);

    try {
      final token = await repo.login(email, password);
      state = state.copyWith(loading: false, token: token);
    } catch (e) {
      state = state.copyWith(loading: false, error: AppString.msg_something_went_wrong);
    }

  }
}
