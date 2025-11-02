import '../entities/user_token.dart';

abstract class AuthRepository {
  Future<UserToken> login(String email, String password);

  Future<UserToken?> getSavedToken();

  Future<void> logout();
}
