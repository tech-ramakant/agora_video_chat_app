import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_chat_demo/core/app_constants.dart';
import 'package:video_chat_demo/features/auth/data/sources/auth_local_source.dart';
import 'package:video_chat_demo/features/video_call/presentation/notifiers/video_call_notifier.dart' as ui;

import '../../core/network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/sources/auth_remote_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/data/sources/user_local_source.dart';
import '../../features/users/data/sources/user_remote_source.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/presentation/notifiers/user_notifier.dart';
import '../../features/video_call/data/repositories/video_call_repository_impl.dart';
import '../../features/video_call/domain/repositories/video_call_repository.dart';
import '../../features/video_call/presentation/notifiers/video_call_notifier.dart';


// Core
final apiClientProvider = Provider((ref) => ApiClient(baseUrl: AppConstants.BASE_URL));

// auth
final authRemoteSourceProvider = Provider<AuthRemoteSource>(
      (ref) => AuthRemoteSourceImpl(ref.read(apiClientProvider)),
);

final authLocalSourceProvider = Provider<AuthLocalSource>(
      (ref) => AuthLocalSourceImpl(),
);

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepositoryImpl(
    ref.read(authRemoteSourceProvider),
    ref.read(authLocalSourceProvider),
  ),
);

final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

// Video call
// final agoraServiceProvider = Provider((ref) => AgoraService(AppConstants.AGORA_API_ID));
//
// final videoCallRepositoryProvider = Provider<VideoCallRepository>(
//       (ref) => VideoCallRepositoryImpl(ref.read(agoraServiceProvider)),
// );
//
// final videoCallNotifierProvider =
// StateNotifierProvider<VideoCallNotifier, VideoCallState>(
//       (ref) => VideoCallNotifier(ref.read(videoCallRepositoryProvider)),
// );

// Users listing
final userRemoteSourceProvider = Provider<UserRemoteSource>((ref) {
  final api = ref.read(apiClientProvider);
  return UserRemoteSource(api);
});

final userLocalSourceProvider = Provider((ref) => UserLocalSource());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.read(userRemoteSourceProvider),
    ref.read(userLocalSourceProvider),
  );
});

final userNotifierProvider =
StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

//
// final videoCallNotifierProvider =
// StateNotifierProvider<VideoCallNotifier, VideoCallState>((ref) {
//   return VideoCallNotifier(ref.read(callRepositoryProvider));
// });

final videoCallRepositoryProvider = Provider<VideoCallRepository>((ref) {
  return VideoCallRepositoryImpl();
});

final videoCallNotifierProvider =
StateNotifierProvider<VideoCallNotifier, ui.VideoCallState>((ref) {
  return VideoCallNotifier(ref.read(videoCallRepositoryProvider));
});