import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/video_repository.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  File? _videoFile;
  VideoPlayerController? _videoCtrl;
  final _captionCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      _videoFile = File(picked.path);
      _videoCtrl = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoCtrl!.play();
          _videoCtrl!.setLooping(true);
        });
    }
  }

  Future<void> _upload() async {
    if (_videoFile == null || _captionCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    final res = await getIt<VideoRepository>().uploadVideo(
      filePath: _videoFile!.path,
      caption: _captionCtrl.text.trim(),
    );
    res.fold(
      (f) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message)));
      },
      (video) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع الفيديو بنجاح!')));
      },
    );
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع فيديو جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_videoCtrl != null && _videoCtrl!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoCtrl!.value.aspectRatio,
                child: VideoPlayer(_videoCtrl!),
              )
            else
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library, size: 50, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('اضغط لاختيار فيديو من الاستوديو'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'اكتب وصفاً للفيديو...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _upload,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('نشر الفيديو'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
