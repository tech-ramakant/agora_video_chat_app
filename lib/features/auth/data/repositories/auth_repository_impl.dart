import '../../domain/entities/user_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request.dart';
import '../sources/auth_local_source.dart';
import '../sources/auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remote;
  final AuthLocalSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<UserToken> login(String email, String password) async {
    final result = await remote.login(
      LoginRequest(email: email, password: password),
    );
    await local.saveToken(result.token);
    return UserToken(token: result.token);
  }

  @override
  Future<UserToken?> getSavedToken() async {
    final token = await local.getToken();
    if (token != null) return UserToken(token: token);
    return null;
  }

  @override
  Future<void> logout() async => local.clearToken();
}

