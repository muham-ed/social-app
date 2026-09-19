import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});
  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  int _idx = 0;
  final _pages = const [_HomeTab(), _RoomsTab(), _DiscoverTab(), _MessagesTab(), _ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _pages[_idx],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _idx,
          onDestinationSelected: (i) => setState(() => _idx = i),
          backgroundColor: const Color(0xFF1E1E2E),
          indicatorColor: const Color(0xFF6C5CE7),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home, color: Colors.white70), selectedIcon: Icon(Icons.home, color: Colors.white), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.mic_none, color: Colors.white70), selectedIcon: Icon(Icons.mic, color: Colors.white), label: 'الغرف'),
            NavigationDestination(icon: Icon(Icons.explore_outlined, color: Colors.white70), selectedIcon: Icon(Icons.explore, color: Colors.white), label: 'اكتشف'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline, color: Colors.white70), selectedIcon: Icon(Icons.chat_bubble, color: Colors.white), label: 'الرسائل'),
            NavigationDestination(icon: Icon(Icons.person_outline, color: Colors.white70), selectedIcon: Icon(Icons.person, color: Colors.white), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final videos = [
      {'name': 'Sara Ahmed', 'user': '@sara', 'caption': 'أجمل لحظات السفر 🌍✈️', 'likes': '1.2K', 'comments': '45', 'color': Color(0xFF6C5CE7)},
      {'name': 'Mohamed Ali', 'user': '@mohamed', 'caption': 'تقنيات جديدة في عالم AI 🤖', 'likes': '890', 'comments': '32', 'color': Color(0xFFFD79A8)},
      {'name': 'Layla Hassan', 'user': '@layla', 'caption': 'وصفة سريعة وسهلة 🍕', 'likes': '2.1K', 'comments': '78', 'color': Color(0xFF00CEC9)},
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (_, i) {
              final v = videos[i];
              return Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [v['color'] as Color, Colors.black])),
                  child: const Center(child: Icon(Icons.play_circle_outline, color: Colors.white24, size: 120)),
                ),
                Positioned(left: 16, right: 80, bottom: 24, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      CircleAvatar(backgroundColor: v['color'] as Color, radius: 20, child: Text((v['name'] as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 10),
                      Text(v['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                    const SizedBox(height: 8),
                    Text(v['caption'] as String, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                )),
                Positioned(right: 12, bottom: 100, child: Column(children: [
                  _icon(Icons.favorite, v['likes'] as String, Colors.red),
                  const SizedBox(height: 20),
                  _icon(Icons.comment, v['comments'] as String, Colors.white),
                  const SizedBox(height: 20),
                  _icon(Icons.share, 'مشاركة', Colors.white),
                ])),
              ]);
            },
          ),
          Positioned(top: 60, right: 16, child: SafeArea(child: FloatingActionButton(
            heroTag: 'video',
            mini: true,
            backgroundColor: const Color(0xFF6C5CE7),
            onPressed: () => context.push('/create-video'),
            child: const Icon(Icons.add, color: Colors.white),
          ))),
        ],
      ),
    );
  }
  Widget _icon(IconData i, String l, Color c) => Column(children: [
    Icon(i, color: c, size: 34),
    const SizedBox(height: 4),
    Text(l, style: const TextStyle(color: Colors.white, fontSize: 12)),
  ]);
}

class _RoomsTab extends StatelessWidget {
  const _RoomsTab();
  @override
  Widget build(BuildContext context) {
    final rooms = [
      {'title': 'Music Lovers 🎤', 'cat': 'Music', 'count': 42, 'live': true, 'color': Color(0xFF6C5CE7)},
      {'title': 'Tech Talk 💻', 'cat': 'Technology', 'count': 28, 'live': true, 'color': Color(0xFF00CEC9)},
      {'title': 'Gamers Lounge 🎮', 'cat': 'Gaming', 'count': 56, 'live': true, 'color': Color(0xFFFD79A8)},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1E2E), foregroundColor: Colors.white, title: const Text('الغرف الصوتية'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'room',
        backgroundColor: const Color(0xFF6C5CE7),
        onPressed: () => context.push('/create-room'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('غرفة جديدة', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rooms.length,
        itemBuilder: (_, i) {
          final r = rooms[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [r['color'] as Color, Colors.cyan]), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.mic, color: Colors.white, size: 30)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (r['live'] as bool) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), margin: const EdgeInsets.only(bottom: 6), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)), child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                Text(r['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${r['cat']} • ${r['count']} مستمع', style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ])),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ]),
          );
        },
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();
  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Sara', 'user': '@sara', 'dist': '2 كم', 'color': Color(0xFF6C5CE7)},
      {'name': 'Mohamed', 'user': '@mohamed', 'dist': '3 كم', 'color': Color(0xFFFD79A8)},
      {'name': 'Layla', 'user': '@layla', 'dist': '5 كم', 'color': Color(0xFF00CEC9)},
      {'name': 'Ahmed', 'user': '@ahmed', 'dist': '7 كم', 'color': Color(0xFFE17055)},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1E2E), foregroundColor: Colors.white, title: const Text('اكتشف القريبين'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(radius: 35, backgroundColor: u['color'] as Color, child: Text((u['name'] as String)[0], style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              Text(u['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(u['user'] as String, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.location_on, color: Colors.cyan, size: 14),
                const SizedBox(width: 4),
                Text(u['dist'] as String, style: const TextStyle(color: Colors.cyan, fontSize: 12)),
              ]),
            ]),
          );
        },
      ),
    );
  }
}

class _MessagesTab extends StatelessWidget {
  const _MessagesTab();
  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Sara', 'msg': 'أهلاً، كيف حالك؟', 'time': '00:21', 'unread': 2, 'color': Color(0xFF6C5CE7)},
      {'name': 'Mohamed', 'msg': 'أراك في الغرفة!', 'time': 'أمس', 'unread': 0, 'color': Color(0xFFFD79A8)},
      {'name': 'Layla', 'msg': 'شكراً لك 🙏', 'time': 'أمس', 'unread': 0, 'color': Color(0xFF00CEC9)},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, title: const Text('الرسائل'), centerTitle: true),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final c = chats[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(radius: 26, backgroundColor: c['color'] as Color, child: Text((c['name'] as String)[0], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
            title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(c['msg'] as String, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(c['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              if ((c['unread'] as int) > 0) CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Text('${c['unread']}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
            ]),
          );
        },
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)])),
            child: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
              CircleAvatar(radius: 45, backgroundColor: Colors.white24, child: Text('A', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))),
              SizedBox(height: 8),
              Text('Ahmed', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text('ahmed@example.com', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]))),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _stat('12', 'Rooms'),
              _stat('345', 'Following'),
              _stat('1.2K', 'Followers'),
            ]),
          ),
        ]),
      ),
    );
  }
  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    Text(l, style: const TextStyle(color: Colors.white60, fontSize: 12)),
  ]);
}
