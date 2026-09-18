import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedTab = 0;

  // Mock data representing standard fields for application control
  final List<Map<String, dynamic>> _users = [
    {'id': '1', 'name': 'أحمد عبد الله', 'username': 'ahmed99', 'role': 'user', 'isBanned': false, 'email': 'ahmed@test.com'},
    {'id': '2', 'name': 'سارة محمد', 'username': 'sara_m', 'role': 'user', 'isBanned': true, 'email': 'sara@test.com'},
    {'id': '3', 'name': 'محمد علي', 'username': 'admin_mo', 'role': 'admin', 'isBanned': false, 'email': 'admin@test.com'},
  ];

  final List<Map<String, dynamic>> _reports = [
    {'id': 'r1', 'reporter': 'ahmed99', 'targetType': 'video', 'targetId': 'v101', 'reason': 'spam', 'description': 'محتوى دعائي متكرر مزعج جداً', 'status': 'pending'},
    {'id': 'r2', 'reporter': 'user_xyz', 'targetType': 'user', 'targetId': '2', 'reason': 'harassment', 'description': 'توجيه إساءات متكررة في الغرف الصوتية', 'status': 'resolved'},
  ];

  final List<Map<String, dynamic>> _rooms = [
    {'id': 'rm1', 'title': 'مناقشات الذكاء الاصطناعي البرمجية', 'type': 'audio', 'owner': 'أحمد عبد الله', 'listeners': 42, 'isActive': true},
    {'id': 'rm2', 'title': 'بث مباشر - خواطر وتصميم هندسي', 'type': 'video', 'owner': 'مهندس رامي', 'listeners': 156, 'isActive': true},
  ];

  final List<Map<String, dynamic>> _videos = [
    {'id': 'v101', 'author': 'ahmed99', 'caption': 'تطوير تطبيق تواصل اجتماعي مبتكر بـ Flutter #برمجة', 'views': 1240, 'likes': 380},
    {'id': 'v102', 'author': 'sara_m', 'caption': 'أفضل النصائح لتصميم شاشات فيجما جذابة وسلسة', 'views': 9500, 'likes': 2400},
  ];

  final _notifTitleCtrl = TextEditingController();
  final _notifBodyCtrl = TextEditingController();

  void _toggleBan(int index) {
    setState(() {
      _users[index]['isBanned'] = !_users[index]['isBanned'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_users[index]['isBanned'] ? 'تم حظر المستخدم بنجاح' : 'تم إلغاء حظر المستخدم')),
    );
  }

  void _closeRoom(int index) {
    setState(() {
      _rooms[index]['isActive'] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إغلاق الغرفة وإنهاء البث بنجاح')),
    );
  }

  void _deleteVideo(String id) {
    setState(() {
      _videos.removeWhere((v) => v['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف الفيديو لمخالفته شروط الاستخدام')),
    );
  }

  void _sendGlobalNotification() {
    if (_notifTitleCtrl.text.trim().isEmpty || _notifBodyCtrl.text.trim().isEmpty) return;
    _notifTitleCtrl.clear();
    _notifBodyCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الإشعار الجماعي لكافة مستخدمي التطبيق بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 260,
            color: const Color(0xFF1A1A2E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  color: const Color(0xFF151525),
                  child: Row(
                    children: [
                      const Icon(Icons.admin_panel_settings, color: Color(0xFF6C5CE7), size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'لوحة التحكم',
                        style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sidebarItem(0, Icons.insert_chart_outlined, 'الإحصائيات العامة'),
                _sidebarItem(1, Icons.people_outline, 'إدارة المستخدمين'),
                _sidebarItem(2, Icons.report_problem_outlined, 'بلاغات المحتوى (UGC)'),
                _sidebarItem(3, Icons.mic_external_on_outlined, 'إدارة الغرف النشطة'),
                _sidebarItem(4, Icons.video_library_outlined, 'المنشورات والفيديوهات'),
                _sidebarItem(5, Icons.campaign_outlined, 'الإشعارات الجماعية'),
              ],
            ),
          ),
          // Main content section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: _buildActiveTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.15) : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildStatistics();
      case 1:
        return _buildUsersManager();
      case 2:
        return _buildReportsManager();
      case 3:
        return _buildRoomsManager();
      case 4:
        return _buildVideosManager();
      case 5:
        return _buildNotificationSender();
      default:
        return const Center(child: Text('قيد التطوير'));
    }
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نظرة عامة وإحصائيات المنصة', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          children: [
            _statCard('إجمالي المستخدمين', '142,530', Icons.people, Colors.blue),
            const SizedBox(width: 20),
            _statCard('الغرف النشطة حالياً', '248', Icons.mic, Colors.purple),
            const SizedBox(width: 20),
            _statCard('البلاغات المعلقة', '${_reports.where((r)=>r['status']=='pending').length}', Icons.warning, Colors.amber),
            const SizedBox(width: 20),
            _statCard('إجمالي الفيديوهات القصيرة', '89,410', Icons.video_collection, Colors.pink),
          ],
        ),
        const SizedBox(height: 40),
        Text('مؤشرات أداء البث والاتصال', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF2D2D44), borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.speed, size: 48, color: Color(0xFF00CEC9)),
                  const SizedBox(height: 12),
                  Text('معدل Latency الحالي لخدمات Agora/WebRTC: 45ms (ممتاز)', style: GoogleFonts.cairo(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('استهلاك الـ Cache للفيديوهات القصيرة ومعدل التحميل التكيفي: 94.2% فاعلية', style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D44),
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(value, style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            Icon(icon, color: color.withOpacity(0.8), size: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إدارة المستخدمين والصلاحيات المطلقة', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF2D2D44), borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              itemCount: _users.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
              itemBuilder: (context, i) {
                final u = _users[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Text(u['name'][0], style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('${u['name']} (@${u['username']})'),
                  subtitle: Text('البريد: ${u['email']} | الدور: ${u['role'] == 'admin' ? 'مدير النظام' : 'مستخدم'}'),
                  trailing: ElevatedButton(
                    onPressed: () => _toggleBan(i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: u['isBanned'] ? Colors.green : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(u['isBanned'] ? 'إلغاء الحظر' : 'حظر الحساب'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نظام الإشراف والحماية والمحتوى المُبلغ عنه (UGC Compliance)', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('مراجعة بلاغات الحظر الصارمة لتلبية شروط متجر آبل وجوجل بلاي', style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _reports.length,
            itemBuilder: (context, i) {
              final r = _reports[i];
              return Card(
                color: const Color(0xFF2D2D44),
                margin: const EdgeInsets.bottom(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('بلاغ رقم: ${r['id']} | نوع الهدف: ${r['targetType']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFD79A8))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: r['status'] == 'pending' ? Colors.amber.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(r['status'] == 'pending' ? 'معلق' : 'تمت المعالجة', style: TextStyle(color: r['status'] == 'pending' ? Colors.amber : Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('المُبلغ: @${r['reporter']} | معرّف المحتوى المخالف: ${r['targetId']}'),
                      Text('سبب البلاغ الرئيسي: ${r['reason']}'),
                      const SizedBox(height: 6),
                      Text('تفاصيل إضافية: ${r['description']}', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      if (r['status'] == 'pending')
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  r['status'] = 'resolved';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم اتخاذ إجراء فوري وحذف المحتوى المخالف لحماية بيئة التطبيق')));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7)),
                              child: const Text('اتخاذ إجراء وحذف'),
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  r['status'] = 'resolved';
                                });
                              },
                              child: const Text('تجاهل البلاغ'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomsManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التحكم والسيطرة المطلقة على غرف المحادثة الجماعية', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF2D2D44), borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              itemCount: _rooms.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white12),
              itemBuilder: (context, i) {
                final rm = _rooms[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Icon(rm['type'] == 'video' ? Icons.videocam : Icons.mic, color: const Color(0xFF6C5CE7), size: 28),
                  title: Text(rm['title']),
                  subtitle: Text('المالك: ${rm['owner']} | الحاضرون حالياً: ${rm['listeners']} مستخدم'),
                  trailing: rm['isActive']
                      ? ElevatedButton(
                          onPressed: () => _closeRoom(i),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('إغلاق الغرفة فوراً'),
                        )
                      : const Text('تم إنهاؤها وإغلاقها', style: TextStyle(color: Colors.grey)),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideosManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إدارة المنشورات ومقاطع الفيديو القصيرة', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
            ),
            itemCount: _videos.length,
            itemBuilder: (context, i) {
              final v = _videos[i];
              return Card(
                color: const Color(0xFF2D2D44),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('@${v['author']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00CEC9))),
                          const SizedBox(height: 6),
                          Text(v['caption'], maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('👁️ ${v['views']} | ❤️ ${v['likes']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                            onPressed: () => _deleteVideo(v['id']),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('بث الإشعارات الجماعية واللحظية لكافة المشتركين', style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: const Color(0xFF2D2D44), borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _notifTitleCtrl,
                decoration: const InputDecoration(
                  labelText: 'عنوان الإشعار البارز',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notifBodyCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'نص ومضمون الرسالة التنبيهية الجماعية',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _sendGlobalNotification,
                icon: const Icon(Icons.send),
                label: const Text('بث تنبيه فوري لحظي (Push Notification)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: const Color(0xFF6C5CE7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
