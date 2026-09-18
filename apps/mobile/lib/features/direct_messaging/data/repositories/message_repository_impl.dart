import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/websocket_client.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _remote;
  final WebSocketClient _wsClient;
  
  MessageRepositoryImpl(this._remote, this._wsClient);

  @override
  Future<Either<Failure, List<Conversation>>> listConversations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final conversations = await _remote.listConversations(page: page, limit: limit);
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessagesHistory(
    String userId, {
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final history = await _remote.getMessagesHistory(userId, page: page, limit: limit);
      return Right(history);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Message>> watchMessages(String userId) async* {
    final socket = await _wsClient.connect();
    final controller = StreamController<Either<Failure, Message>>();

    socket.on('message:$userId', (data) {
      try {
        final message = MessageModel.fromJson(data as Map<String, dynamic>);
        controller.add(Right(message));
      } catch (e) {
        controller.add(const Left(ServerFailure('Data parsing error')));
      }
    });

    // تنظيف عند إغلاق الـ Stream
    yield* controller.stream;
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String receiverId,
    required String clientSideId,
    String? text,
    String? mediaUrl,
    MessageMediaType type = MessageMediaType.text,
  }) async {
    try {
      final message = await _remote.sendMessage(
        receiverId: receiverId,
        clientSideId: clientSideId,
        text: text,
        mediaUrl: mediaUrl,
        type: type,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String userId) async {
    try {
      await _remote.markAsRead(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser(String userId) async {
    try {
      await _remote.blockUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportMessage({
    required String messageId,
    required String reason,
  }) async {
    try {
      await _remote.reportMessage(messageId, reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
