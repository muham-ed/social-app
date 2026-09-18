import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../config/env.dart';

class AgoraService {
  RtcEngine? _engine;

  Future<RtcEngine> init({required bool isVideo}) async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: Env.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine!.enableAudio();
    if (isVideo) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    }
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    return _engine!;
  }

  Future<void> join({required String token, required String channel, required int uid}) async {
    await _engine?.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leave() async => _engine?.leaveChannel();
  Future<void> mute(bool muted) async => _engine?.muteLocalAudioStream(muted);
  Future<void> toggleCamera(bool enabled) async => _engine?.muteLocalVideoStream(!enabled);
  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
  }

  RtcEngine? get engine => _engine;
}