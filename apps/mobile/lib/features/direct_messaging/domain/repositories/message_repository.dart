import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/conversation.dart';

enum MessageMediaType { text, image, video, audio }

abstract class MessageRepository {
  /// جلب قائمة المحادثات مع دعم الترقيم (Pagination)
  Future<Either<Failure, List<Conversation>>> listConversations({
    int page = 1,
    int limit = 20,
  });

  /// جلب الرسائل السابقة لمحادثة معينة
  Future<Either<Failure, List<Message>>> getMessagesHistory(
    String userId, {
    int page = 1,
    int limit = 30,
  });

  /// مراقبة الرسائل الجديدة فورياً (Real-time)
  Stream<Either<Failure, Message>> watchMessages(String userId);

  /// إرسال رسالة جديدة
  /// [clientSideId] مهم جداً لربط الرسالة في الواجهة قبل وصول رد السيرفر
  Future<Either<Failure, Message>> sendMessage({
    required String receiverId,
    required String clientSideId,
    String? text,
    String? mediaUrl,
    MessageMediaType type = MessageMediaType.text,
  });

  /// تحديد الرسائل كمقروءة
  Future<Either<Failure, void>> markAsRead(String userId);

  /// --- نظام الحماية والإشراف (UGC Policy) ---
  
  /// حظر مستخدم من إرسال رسائل
  Future<Either<Failure, void>> blockUser(String userId);

  /// التبليغ عن رسالة مسيئة
  Future<Either<Failure, void>> reportMessage({
    required String messageId,
    required String reason,
  });
}
