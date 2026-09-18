import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/rooms_bloc.dart';
import 'room_chat_page.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});
  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  void initState() {
    super.initState();
    getIt<RoomsBloc>().add(const RoomsLoad());
  }

  void _showCreateSheet() {
    final titleCtrl = TextEditingController();
    String type = 'audio';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: StatefulBuilder(
          builder: (ctx, setStateSheet) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('إنشاء غرفة جديدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AppTextField(controller: titleCtrl, hint: 'عنوان الغرفة', icon: Icons.title),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'audio', label: Text('صوتية'), icon: Icon(Icons.mic)),
                  ButtonSegment(value: 'video', label: Text('مرئية'), icon: Icon(Icons.videocam)),
                ],
                selected: {type},
                onSelectionChanged: (s) => setStateSheet(() => type = s.first),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'إنشاء',
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  context.read<RoomsBloc>().add(RoomCreate(titleCtrl.text.trim(), type));
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<RoomsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('الغرف الصوتية والمرئية')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateSheet,
          icon: const Icon(Icons.add),
          label: const Text('غرفة جديدة'),
        ),
        body: BlocBuilder<RoomsBloc, RoomsState>(
          builder: (context, state) {
            if (state is RoomsLoading) return const Center(child: CircularProgressIndicator());
            if (state is RoomsError) return Center(child: Text(state.message));
            if (state is RoomsLoaded) {
              if (state.rooms.isEmpty) {
                return const Center(child: Text('لا توجد غرف نشطة'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.rooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final room = state.rooms[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: room.type == 'video' ? Colors.pink : Colors.deepPurple,
                        child: Icon(room.type == 'video' ? Icons.videocam : Icons.mic, color: Colors.white),
                      ),
                      title: Text(room.title),
                      subtitle: Text('${room.owner.name} • ${room.listenersCount} مستمع'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RoomChatPage(room: room)),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
