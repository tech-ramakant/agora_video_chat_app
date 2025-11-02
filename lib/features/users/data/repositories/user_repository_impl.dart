import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../sources/user_local_source.dart';
import '../sources/user_remote_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteSource remote;
  final UserLocalSource local;

  UserRepositoryImpl(this.remote, this.local);

  @override
  Future<List<User>> fetchUsers(int page) async {
    try {
      final users = await remote.getUsers(page);
      if (page == 1) await local.cacheUsers(users);
      return users;
    } catch (_) {
      // fallback to cache
      if (page == 1) return local.getCachedUsers();
      rethrow;
    }
  }
}
