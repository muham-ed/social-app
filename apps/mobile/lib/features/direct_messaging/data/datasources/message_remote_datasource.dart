import '../../../../core/network/api_client.dart';
import '../../domain/repositories/message_repository.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class MessageRemoteDataSource {
  final ApiClient _client;
  MessageRemoteDataSource(this._client);

  Future<List<ConversationModel>> listConversations({int page = 1, int limit = 20}) async {
    final res = await _client.get('/messages', query: {'page': page, 'limit': limit});
    final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(ConversationModel.fromJson).toList();
  }

  Future<List<MessageModel>> getMessagesHistory(String userId, {int page = 1, int limit = 30}) async {
    final res = await _client.get('/messages/$userId', query: {'page': page, 'limit': limit});
    final list = (res.data['data']['messages'] as List).cast<Map<String, dynamic>>();
    return list.map(MessageModel.fromJson).toList();
  }

  Future<MessageModel> sendMessage({
    required String receiverId,
    required String clientSideId,
    String? text,
    String? mediaUrl,
    MessageMediaType type = MessageMediaType.text,
  }) async {
    final res = await _client.post('/messages/$receiverId', data: {
      'clientSideId': clientSideId,
      'text': text ?? '',
      'mediaUrl': mediaUrl ?? '',
      'type': type.name,
    });
    return MessageModel.fromJson(res.data['data']);
  }

  Future<void> markAsRead(String userId) => _client.post('/messages/$userId/read');

  Future<void> blockUser(String userId) => _client.post('/users/$userId/block');

  Future<void> reportMessage(String messageId, String reason) => _client.post('/messages/$messageId/report', data: {'reason': reason});
}
