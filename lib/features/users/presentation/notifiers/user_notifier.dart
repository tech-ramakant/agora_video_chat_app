import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserState {
  final List<User> users;
  final bool loading;
  final int currentPage;
  final bool hasMore;
  final String? error;

  const UserState({
    this.users = const [],
    this.loading = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
  });

  UserState copyWith({
    List<User>? users,
    bool? loading,
    int? currentPage,
    bool? hasMore,
    String? error,
  }) {
    return UserState(
      users: users ?? this.users,
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository repo;

  UserNotifier(this.repo) : super(const UserState()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.loading || !state.hasMore) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final users = await repo.fetchUsers(state.currentPage);
      if (users.isEmpty) {
        state = state.copyWith(loading: false, hasMore: false);
      } else {
        state = state.copyWith(
          loading: false,
          users: [...state.users, ...users],
          currentPage: state.currentPage + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
