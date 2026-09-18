import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/message_repository.dart';

class Message extends Equatable {
  final String id;
  final String? clientSideId; // للمعالجة في الواجهة قبل الحفظ في السيرفر
  final User sender;
  final User receiver;
  final String text;
  final String mediaUrl;
  final MessageMediaType type;
  final bool isRead;
  final DateTime createdAt;

  const Message({
    required this.id,
    this.clientSideId,
    required this.sender,
    required this.receiver,
    this.text = '',
    this.mediaUrl = '',
    this.type = MessageMediaType.text,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, clientSideId, text, mediaUrl, type, isRead];
}

class Conversation extends Equatable {
  final String id;
  final Message lastMessage;
  final int unread;

  const Conversation({
    required this.id,
    required this.lastMessage,
    this.unread = 0,
  });

  @override
  List<Object?> get props => [id, lastMessage, unread];
}
