import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/conversations_bloc.dart';
import 'chat_page.dart';
import '../../../auth/data/models/user_model.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return BlocProvider.value(
      value: getIt<ConversationsBloc>()..add(const ConversationsLoad()),
      child: Scaffold(
        appBar: AppBar(title: const Text('الرسائل')),
        body: BlocBuilder<ConversationsBloc, ConversationsState>(
          builder: (context, state) {
            if (state is ConversationsLoading) return const Center(child: CircularProgressIndicator());
            if (state is ConversationsError) return Center(child: Text(state.message));
            if (state is ConversationsLoaded) {
              if (state.items.isEmpty) return const Center(child: Text('لا توجد محادثات'));
              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final conv = state.items[i];
                  final last = conv.lastMessage;
                  final other = last.sender.id == currentUser.id
                      ? last.receiver
                      : last.sender;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: other.avatar.isNotEmpty
                          ? NetworkImage(other.avatar)
                          : null,
                      child: other.avatar.isEmpty
                          ? Text(other.name.isNotEmpty ? other.name[0] : '?')
                          : null,
                    ),
                    title: Text(other.name),
                    subtitle: Text(last.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: conv.unread > 0
                        ? CircleAvatar(radius: 12, child: Text('${conv.unread}', style: const TextStyle(fontSize: 11)))
                        : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(user: other),
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
