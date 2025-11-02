import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_chat_demo/features/video_call/domain/repositories/video_call_repository.dart';

class VideoCallState {
  final bool localJoined;
  final int? remoteUid;
  final bool isMuted;
  final bool videoEnabled;
  final bool isScreenSharing;

  const VideoCallState({
    this.localJoined = false,
    this.remoteUid,
    this.isMuted = false,
    this.videoEnabled = true,
    this.isScreenSharing = false,
  });

  VideoCallState copyWith({
    bool? localJoined,
    int? remoteUid,
    bool? isMuted,
    bool? videoEnabled,
    bool? isScreenSharing,
  }) {
    return VideoCallState(
      localJoined: localJoined ?? this.localJoined,
      remoteUid: remoteUid ?? this.remoteUid,
      isMuted: isMuted ?? this.isMuted,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }
}

class VideoCallNotifier extends StateNotifier<VideoCallState> {
  final VideoCallRepository repo;
  VideoCallNotifier(this.repo) : super(const VideoCallState());

  Future<void> initialize() async {
    await repo.initAgora(
      onUserJoined: (uid) => state = state.copyWith(remoteUid: uid),
      onUserOffline: (uid) => state = state.copyWith(remoteUid: null),
    );
  }

  Future<void> join(String token, String channel) async {
    await repo.join(channel, token, 0);
    state = state.copyWith(localJoined: true);
  }

  Future<void> toggleMute() async {
    final muted = !state.isMuted;
    await repo.engine.muteLocalAudioStream(muted);
    state = state.copyWith(isMuted: muted);
  }

  Future<void> toggleVideo() async {
    final enabled = !state.videoEnabled;
    await repo.engine.muteLocalVideoStream(!enabled);
    state = state.copyWith(videoEnabled: enabled);
  }

  Future<void> switchCamera() async {
    await repo.engine.switchCamera();
  }

  Future<void> leave() async {
    await repo.leave();
    state = const VideoCallState();
  }

  // Optional: Screen Share Feature (Android/Windows)
  Future<void> toggleScreenShare() async {
    final sharing = !state.isScreenSharing;
    if (sharing) {
      await repo.engine.startScreenCapture(ScreenCaptureParameters2());
    } else {
      await repo.engine.stopScreenCapture();
    }
    state = state.copyWith(isScreenSharing: sharing);
  }
}
