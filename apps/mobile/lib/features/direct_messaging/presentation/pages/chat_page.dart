import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/user.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  late final ChatBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ChatBloc>()..add(ChatLoadStarted(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.user.avatar),
              ),
              const SizedBox(width: 10),
              Text(widget.user.name, style: const TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'block') _showBlockDialog();
                if (val == 'report') _showReportDialog();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'report', child: Text('تبليغ')),
                const PopupMenuItem(value: 'block', child: Text('حظر', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
                  if (state is ChatError) return Center(child: Text(state.message));
                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) return const Center(child: Text('لا توجد رسائل بعد. ابدأ المحادثة!'));
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: state.messages.length,
                      itemBuilder: (_, i) {
                        final m = state.messages[i];
                        final mine = m.sender.id != widget.user.id;
                        return _MessageBubble(message: m.text, isMine: mine, time: m.createdAt);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isBlocked = state is ChatLoaded && state.isBlocked;
        if (isBlocked) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: const Center(child: Text('لقد قمت بحظر هذا المستخدم', style: TextStyle(color: Colors.red))),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.deepPurple, size: 28),
                  onPressed: () {
                    if (_ctrl.text.trim().isEmpty) return;
                    _bloc.add(ChatMessageSent(text: _ctrl.text.trim()));
                    _ctrl.clear();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حظر المستخدم؟'),
        content: const Text('لن تتمكن من استلام رسائل من هذا المستخدم بعد الآن.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              _bloc.add(ChatUserBlocked());
              Navigator.pop(ctx);
            },
            child: const Text('حظر', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    // منطق التبليغ - يمكن توسيعه ليشمل أسباباً محددة
    _bloc.add(const ChatMessageReported('last_msg_id', 'محتوى غير لائق'));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال التبليغ للإدارة')));
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMine;
  final DateTime time;
  const _MessageBubble({required this.message, required this.isMine, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMine ? 20 : 0),
            bottomRight: Radius.circular(isMine ? 0 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message, style: TextStyle(color: isMine ? Colors.white : Colors.black87, fontSize: 15)),
            const SizedBox(height: 4),
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(color: isMine ? Colors.white70 : Colors.black45, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
