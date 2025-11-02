

class VideoCallState {
  final bool joined;
  final bool muted;
  final bool videoEnabled;
  final int? remoteUid;
  final bool screenSharing;

  const VideoCallState({
    this.joined = false,
    this.muted = false,
    this.videoEnabled = true,
    this.remoteUid,
    this.screenSharing = false,
  });

  VideoCallState copyWith({
    bool? joined,
    bool? muted,
    bool? videoEnabled,
    int? remoteUid,
    bool? screenSharing,
  }) {
    return VideoCallState(
      joined: joined ?? this.joined,
      muted: muted ?? this.muted,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      remoteUid: remoteUid ?? this.remoteUid,
      screenSharing: screenSharing ?? this.screenSharing,
    );
  }
}
