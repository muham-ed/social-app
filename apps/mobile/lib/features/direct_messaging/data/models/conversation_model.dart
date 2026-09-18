import '../../domain/entities/conversation.dart';
import 'message_model.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.lastMessage,
    super.unread,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] ?? '',
      lastMessage: MessageModel.fromJson(json['lastMessage'] ?? {}),
      unread: json['unread'] ?? 0,
    );
  }
}
