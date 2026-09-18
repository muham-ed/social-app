import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/message_repository.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatLoadStarted extends ChatEvent {
  final String userId;
  const ChatLoadStarted(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ChatMessageSent extends ChatEvent {
  final String text;
  final String? mediaUrl;
  final MessageMediaType type;
  const ChatMessageSent({required this.text, this.mediaUrl, this.type = MessageMediaType.text});
  @override
  List<Object?> get props => [text, mediaUrl, type];
}

class ChatMessageReceived extends ChatEvent {
  final Message message;
  const ChatMessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatUserBlocked extends ChatEvent {}
class ChatMessageReported extends ChatEvent {
  final String messageId;
  final String reason;
  const ChatMessageReported(this.messageId, this.reason);
}

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isBlocked;
  const ChatLoaded({required this.messages, this.isBlocked = false});
  @override
  List<Object?> get props => [messages, isBlocked];
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository _repo;
  late final String _targetUserId;
  StreamSubscription? _msgSubscription;

  ChatBloc(this._repo) : super(ChatInitial()) {
    on<ChatLoadStarted>(_onLoadStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatUserBlocked>(_onUserBlocked);
    on<ChatMessageReported>(_onMessageReported);
  }

  Future<void> _onLoadStarted(ChatLoadStarted event, Emitter<ChatState> emit) async {
    _targetUserId = event.userId;
    emit(ChatLoading());
    
    // بدء مراقبة الرسائل الحية
    _msgSubscription?.cancel();
    _msgSubscription = _repo.watchMessages(_targetUserId).listen((res) {
      res.fold((_) => null, (msg) => add(ChatMessageReceived(msg)));
    });

    final res = await _repo.getMessagesHistory(_targetUserId);
    res.fold(
      (f) => emit(ChatError(f.toString())),
      (msgs) => emit(ChatLoaded(messages: msgs.reversed.toList())),
    );
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoaded) return;
    final currentState = state as ChatLoaded;
    
    final clientSideId = const Uuid().v4();
    
    // إرسال الرسالة للسيرفر
    final res = await _repo.sendMessage(
      receiverId: _targetUserId,
      clientSideId: clientSideId,
      text: event.text,
      mediaUrl: event.mediaUrl,
      type: event.type,
    );

    res.fold(
      (f) => emit(ChatError(f.toString())),
      (msg) {
        // تحديث القائمة بالرسالة المؤكدة من السيرفر
        emit(ChatLoaded(
          messages: [...currentState.messages, msg],
          isBlocked: currentState.isBlocked,
        ));
      },
    );
  }

  void _onMessageReceived(ChatMessageReceived event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      // تجنب التكرار إذا كانت الرسالة هي نفسها التي أرسلها المستخدم ووصلت عبر الـ socket
      if (currentState.messages.any((m) => m.id == event.message.id)) return;
      
      emit(ChatLoaded(
        messages: [...currentState.messages, event.message],
        isBlocked: currentState.isBlocked,
      ));
    }
  }

  Future<void> _onUserBlocked(ChatUserBlocked event, Emitter<ChatState> emit) async {
    final res = await _repo.blockUser(_targetUserId);
    res.fold(
      (f) => null,
      (_) {
        if (state is ChatLoaded) {
          emit(ChatLoaded(messages: (state as ChatLoaded).messages, isBlocked: true));
        }
      },
    );
  }

  Future<void> _onMessageReported(ChatMessageReported event, Emitter<ChatState> emit) async {
    await _repo.reportMessage(messageId: event.messageId, reason: event.reason);
  }

  @override
  Future<void> close() {
    _msgSubscription?.cancel();
    return super.close();
  }
}
