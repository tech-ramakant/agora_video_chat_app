import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  final String appId;
  RtcEngine? _engine;
  int? remoteUid;
  bool _muted = false;
  bool _videoEnabled = true;

  AgoraService(this.appId);

  Future<void> initialize(String channelName) async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));

    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: "",
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  RtcEngine get engine => _engine!;

  Future<void> leave() async {
    await _engine?.leaveChannel();
    await _engine?.release();
  }

  Future<void> toggleMic() async {
    _muted = !_muted;
    await _engine?.muteLocalAudioStream(_muted);
  }

  Future<void> toggleCamera() async {
    _videoEnabled = !_videoEnabled;
    await _engine?.muteLocalVideoStream(!_videoEnabled);
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> startScreenShare() async {
    // Android only
    await _engine?.startScreenCapture(const ScreenCaptureParameters2(
      captureAudio: true,
      captureVideo: true,
    ));
  }
}
