import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/agora_service.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';

class RoomChatPage extends StatefulWidget {
  final Room room;
  const RoomChatPage({super.key, required this.room});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  late final AgoraService _agora;
  final _repo = getIt<RoomRepository>();
  final _msgCtrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  
  bool _muted = false;
  bool _cameraOn = false;
  final Set<int> _remoteUids = {};
  bool _joining = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _agora = getIt<AgoraService>();
    _requestPermissionsAndJoin();
  }

  Future<void> _requestPermissionsAndJoin() async {
    final status = await [
      Permission.microphone,
      if (widget.room.type == 'video') Permission.camera,
    ].request();

    if (status.values.every((s) => s.isGranted)) {
      _join();
    } else {
      setState(() {
        _error = 'الصلاحيات مرفوضة. لا يمكن الانضمام للبث.';
        _joining = false;
      });
    }
  }

  Future<void> _join() async {
    final tokenRes = await _repo.token(widget.room.id);
    tokenRes.fold((f) {
      setState(() {
        _error = f.toString();
        _joining = false;
      });
    }, (data) async {
      try {
        final engine = await _agora.init(isVideo: widget.room.type == 'video');
        
        engine.registerEventHandler(RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (mounted) setState(() => _joining = false);
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (mounted) setState(() => _remoteUids.add(remoteUid));
          },
          onUserOffline: (connection, remoteUid, reason) {
            if (mounted) setState(() => _remoteUids.remove(remoteUid));
          },
          onError: (err, msg) {
            debugPrint('Agora Error: $err, $msg');
          },
        ));

        await _agora.join(
          token: data['token'],
          channel: data['channelName'],
          uid: data['uid'],
        );
      } catch (e) {
        setState(() {
          _error = 'فشل الاتصال بخادم البث';
          _joining = false;
        });
      }
    });
  }

  Future<void> _leave() async {
    try {
      await _repo.leave(widget.room.id);
      await _agora.dispose();
    } catch (_) {}
  }

  @override
  void dispose() {
    _leave();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    // هنا يجب ربط إرسال الرسالة عبر الـ Socket الخاص بالغرفة
    setState(() {
      _messages.add({'mine': true, 'text': _msgCtrl.text.trim(), 'sender': 'أنا'});
      _msgCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.room.type == 'video';
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.room.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${_remoteUids.length + 1} مشارك', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_muted ? Icons.mic_off_rounded : Icons.mic_rounded, color: _muted ? Colors.red : Colors.white),
            onPressed: () async {
              _muted = !_muted;
              await _agora.mute(_muted);
              setState(() {});
            },
          ),
          if (isVideo)
            IconButton(
              icon: Icon(_cameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded),
              onPressed: () async {
                _cameraOn = !_cameraOn;
                await _agora.toggleCamera(_cameraOn);
                setState(() {});
              },
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('خروج', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _error != null
          ? Center(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          ))
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMediaGrid(isVideo),
                ),
                Expanded(
                  flex: 2,
                  child: _buildChatArea(),
                ),
              ],
            ),
    );
  }

  Widget _buildMediaGrid(bool isVideo) {
    if (_joining) return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));

    if (!isVideo) {
      return Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildAudioUserAvatar(widget.room.owner.name, isMe: true),
            ..._remoteUids.map((uid) => _buildAudioUserAvatar('مشارك $uid')),
          ],
        ),
      );
    }

    // شبكة الفيديو
    final allViews = <Widget>[];
    if (_cameraOn) {
      allViews.add(AgoraVideoView(
        controller: VideoViewController(rtcEngine: _agora.engine!, canvas: const VideoCanvas(uid: 0)),
      ));
    }
    for (var uid in _remoteUids) {
      allViews.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agora.engine!,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: widget.room.channelName),
        ),
      ));
    }

    if (allViews.isEmpty) {
      return const Center(child: Text('في انتظار الكاميرات...', style: TextStyle(color: Colors.white38)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: allViews.length,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: allViews[index],
      ),
    );
  }

  Widget _buildAudioUserAvatar(String name, {bool isMe = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: isMe ? Colors.deepPurple : Colors.blueGrey,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 30, color: Colors.white)),
            ),
            if (isMe && _muted)
              const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.mic_off, size: 14, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildChatArea() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${m['sender']}: ', style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                        TextSpan(text: m['text'], style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'قل شيئاً...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.deepPurpleAccent),
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}
