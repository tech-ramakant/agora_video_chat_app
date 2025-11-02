import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_chat_demo/core/app_constants.dart';
import '../../domain/repositories/video_call_repository.dart';

class VideoCallRepositoryImpl implements VideoCallRepository {
  late final RtcEngine _engine;

  @override
  RtcEngine get engine => _engine;

  @override
  Future<void> initAgora({
    required UserJoinedCallback onUserJoined,
    required UserOfflineCallback onUserOffline,
  }) async {
    // Initialize Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: AppConstants.AGORA_API_ID,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    // Set event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection conn, int elapsed) {
          print('✅ Joined channel: ${conn.channelId}');
        },
        onUserJoined: (RtcConnection conn, int uid, int elapsed) {
          print('👤 Remote user joined: $uid');
          onUserJoined(uid);
        },
        onUserOffline:
            (RtcConnection conn, int uid, UserOfflineReasonType reason) {
              print('❌ Remote user left: $uid');
              onUserOffline(uid);
            },
      ),
    );

    // Enable audio and video
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  @override
  Future<void> join(String channel, String token, int uid) async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Future<void> leave() async {
    await _engine.leaveChannel();
    await _engine.stopPreview();
  }
}
