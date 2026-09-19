import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});
  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _type = 'audio';
  bool _isPrivate = false;
  bool _creating = false;

  @override
  void dispose() { _nameCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب اسم الغرفة'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _creating = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _creating = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الغرفة ✅'), backgroundColor: Colors.green));
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.go('/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, title: const Text('غرفة جديدة'), centerTitle: true),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Container(
          width: 100, height: 100,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)]), borderRadius: BorderRadius.circular(28)),
          child: Icon(_type == 'audio' ? Icons.mic : Icons.videocam, color: Colors.white, size: 50),
        )),
        const SizedBox(height: 32),
        const Text('نوع الغرفة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _typeCard('audio', Icons.mic, 'صوتية')),
          const SizedBox(width: 12),
          Expanded(child: _typeCard('video', Icons.videocam, 'مرئية')),
        ]),
        const SizedBox(height: 24),
        const Text('اسم الغرفة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(controller: _nameCtrl, maxLength: 60, decoration: InputDecoration(hintText: 'مثال: Music Lovers 🎤', prefixIcon: const Icon(Icons.title), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
        const SizedBox(height: 12),
        const Text('الوصف (اختياري)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(controller: _descCtrl, maxLines: 3, maxLength: 300, decoration: InputDecoration(hintText: 'عن إيه الغرفة؟', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
        SwitchListTile(
          value: _isPrivate,
          onChanged: (v) => setState(() => _isPrivate = v),
          title: const Text('غرفة خاصة', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('لن تظهر في القائمة العامة'),
          activeColor: const Color(0xFF6C5CE7),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),
        SizedBox(height: 54, child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          onPressed: _creating ? null : _create,
          icon: Icon(_creating ? Icons.hourglass_top : Icons.add_circle),
          label: Text(_creating ? 'جاري الإنشاء...' : 'إنشاء الغرفة', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        )),
      ])),
    );
  }

  Widget _typeCard(String type, IconData icon, String title) {
    final s = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: s ? const Color(0xFF6C5CE7) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: s ? const Color(0xFF6C5CE7) : Colors.grey.shade300, width: 2),
        ),
        child: Column(children: [
          Icon(icon, color: s ? Colors.white : const Color(0xFF6C5CE7), size: 36),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: s ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
        ]),
      ),
    );
  }
}
