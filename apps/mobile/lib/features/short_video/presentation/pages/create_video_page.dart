import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateVideoPage extends StatefulWidget {
  const CreateVideoPage({super.key});
  @override
  State<CreateVideoPage> createState() => _CreateVideoPageState();
}

class _CreateVideoPageState extends State<CreateVideoPage> {
  String? _fileName;
  bool _uploading = false;
  double _progress = 0;

  Future<void> _upload() async {
    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر فيديو أولاً'), backgroundColor: Colors.red));
      return;
    }
    setState(() { _uploading = true; _progress = 0; });
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) setState(() => _progress = i / 100);
    }
    if (!mounted) return;
    setState(() => _uploading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الرفع ✅'), backgroundColor: Colors.green));
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.go('/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, title: const Text('فيديو جديد'), centerTitle: true),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        GestureDetector(
          onTap: _uploading ? null : () => setState(() => _fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4'),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: _fileName == null ? Colors.white : const Color(0xFF6C5CE7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _fileName == null ? Colors.grey.shade300 : const Color(0xFF6C5CE7), width: 2),
            ),
            child: _fileName == null
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  Icon(Icons.video_call, size: 70, color: Color(0xFF6C5CE7)),
                  SizedBox(height: 12),
                  Text('اضغط لاختيار فيديو', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ])
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle, size: 70, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(_fileName!, style: const TextStyle(fontSize: 13)),
                ]),
          ),
        ),
        const SizedBox(height: 24),
        TextField(maxLines: 3, maxLength: 500, decoration: InputDecoration(hintText: 'وصف الفيديو...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
        const SizedBox(height: 12),
        TextField(decoration: InputDecoration(hintText: 'hashtags (مفصولة بفواصل)', prefixIcon: const Icon(Icons.tag), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
        const SizedBox(height: 24),
        if (_uploading) ...[
          LinearProgressIndicator(value: _progress, minHeight: 8),
          const SizedBox(height: 8),
          Text('جاري الرفع... ${(_progress * 100).toStringAsFixed(0)}%', textAlign: TextAlign.center),
          const SizedBox(height: 16),
        ],
        SizedBox(height: 54, child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          onPressed: _uploading ? null : _upload,
          icon: Icon(_uploading ? Icons.hourglass_top : Icons.cloud_upload),
          label: Text(_uploading ? 'جاري الرفع...' : 'نشر الفيديو', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        )),
      ])),
    );
  }
}
