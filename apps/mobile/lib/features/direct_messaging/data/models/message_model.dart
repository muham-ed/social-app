import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/conversation.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.receiver,
    required super.createdAt,
    super.text,
    super.mediaUrl,
    super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: UserModel.fromJson(json['sender'] ?? {}),
      receiver: UserModel.fromJson(json['receiver'] ?? {}),
      text: json['text'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
