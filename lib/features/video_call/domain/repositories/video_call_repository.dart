import 'package:agora_rtc_engine/agora_rtc_engine.dart';

typedef UserJoinedCallback = void Function(int uid);
typedef UserOfflineCallback = void Function(int uid);

abstract class VideoCallRepository {
  RtcEngine get engine;

  Future<void> initAgora({
    required UserJoinedCallback onUserJoined,
    required UserOfflineCallback onUserOffline,
  });

  Future<void> join(String channel, String token, int uid);
  Future<void> leave();
}
