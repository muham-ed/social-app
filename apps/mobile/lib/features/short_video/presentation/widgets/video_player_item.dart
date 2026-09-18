import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/video.dart';
import '../../../../core/config/env.dart';
import '../../../report_block/presentation/widgets/report_sheet.dart';

class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final bool isActive;
  const VideoPlayerItem({super.key, required this.video, required this.isActive});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _ctrl;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = widget.video.videoUrl.startsWith('http')
        ? widget.video.videoUrl
        : '${Env.uploadsUrl}${widget.video.videoUrl}';
    
    // ملاحظة: لتحقيق أداء "لا يُقهر"، يجب استخدام CachedVideoPlayer أو بروكسي محلي
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
    
    try {
      await _ctrl.initialize();
      _ctrl.setLooping(true);
      if (widget.isActive) _ctrl.play();
      if (mounted) setState(() => _initialized = true);
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_initialized) return;
    if (widget.isActive && !oldWidget.isActive) {
      _ctrl.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _ctrl.pause();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (_ctrl.value.isPlaying) {
            _ctrl.pause();
          } else {
            _ctrl.play();
          }
          setState(() {});
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _ctrl.value.aspectRatio,
                  child: VideoPlayer(_ctrl),
                ),
              )
            else
              CachedNetworkImage(
                imageUrl: widget.video.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: Colors.white24)),
              ),
            
            // تدرج لوني خلفي للنصوص لضمان وضوحها
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent, Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            if (!_ctrl.value.isPlaying && _initialized)
              const Center(
                child: Icon(Icons.play_arrow_rounded, color: Colors.white54, size: 100),
              ),

            // أزرار التفاعل الجانبية (TikTok Style)
            Positioned(
              right: 12,
              bottom: 100,
              child: Column(
                children: [
                  _buildSideAction(Icons.favorite, widget.video.likesCount.toString(), Colors.red),
                  const SizedBox(height: 20),
                  _buildSideAction(Icons.comment_rounded, widget.video.commentsCount.toString(), Colors.white),
                  const SizedBox(height: 20),
                  _buildSideAction(Icons.share_rounded, 'مشاركة', Colors.white),
                  const SizedBox(height: 20),
                  _buildSideAction(Icons.report_gmailerrorred, 'تبليغ', Colors.white, onTap: () {
                    _ctrl.pause();
                    ReportSheet.show(context, targetType: 'video', targetId: widget.video.id);
                  }),
                ],
              ),
            ),

            // معلومات الفيديو
            Positioned(
              bottom: 30,
              left: 16,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(widget.video.author.avatar),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '@${widget.video.author.username}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(4)),
                        child: const Text('متابعة', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.video.caption,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideAction(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
