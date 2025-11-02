import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../../core/di/providers.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  const VideoCallScreen({super.key});

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  static const String appId = 'YOUR_APP_ID_HERE';
  static const String channelName = 'meeting_demo'; // hardcoded meeting ID
  static const String token = '';

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  Future<void> _initCall() async {
    final notifier = ref.read(videoCallNotifierProvider.notifier);
    await notifier.initialize();
    await notifier.join(token, channelName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoCallNotifierProvider);
    final notifier = ref.read(videoCallNotifierProvider.notifier);
    final engine = notifier.repo.engine;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        actions: [
          Icon(
            Icons.circle,
            color: state.remoteUid != null ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          state.localJoined
              ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
              : const Center(child: CircularProgressIndicator()),
          if (state.remoteUid != null)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: engine,
                    canvas: VideoCanvas(uid: state.remoteUid),
                    connection: const RtcConnection(channelId: channelName),
                  ),
                ),
              ),
            )
          else
            const Center(
              child: Text(
                'Waiting for remote user to join...',
                style: TextStyle(color: Colors.white70),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _controlButton(
                icon: state.isMuted ? Icons.mic_off : Icons.mic,
                color: state.isMuted ? Colors.grey : Colors.white,
                onPressed: () => notifier.toggleMute(),
              ),
              _controlButton(
                icon: state.videoEnabled ? Icons.videocam : Icons.videocam_off,
                color: state.videoEnabled ? Colors.white : Colors.grey,
                onPressed: () => notifier.toggleVideo(),
              ),
              _controlButton(
                icon: Icons.cameraswitch,
                color: Colors.white,
                onPressed: () => notifier.switchCamera(),
              ),
              _controlButton(
                icon: Icons.screen_share,
                color: state.isScreenSharing ? Colors.blue : Colors.white,
                onPressed: () => notifier.toggleScreenShare(),
              ),
              _controlButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: () async {
                  await notifier.leave();
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.black54,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
