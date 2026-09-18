import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NotificationsBloc>()..add(const NotificationsLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإشعارات'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () => context.read<NotificationsBloc>().add(const NotificationsMarkAll()),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) return const Center(child: CircularProgressIndicator());
            if (state is NotificationsError) return Center(child: Text(state.message));
            if (state is NotificationsLoaded) {
              if (state.items.isEmpty) return const Center(child: Text('لا توجد إشعارات'));
              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = state.items[i];
                  final isRead = n['isRead'] == true;
                  return ListTile(
                    tileColor: isRead ? null : Colors.deepPurple.withOpacity(0.05),
                    leading: const CircleAvatar(child: Icon(Icons.notifications)),
                    title: Text(n['title'] ?? ''),
                    subtitle: Text(n['body'] ?? ''),
                    trailing: isRead
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.mark_email_read),
                            onPressed: () {
                              context.read<NotificationsBloc>().add(NotificationMarkRead(n['_id']));
                            },
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
