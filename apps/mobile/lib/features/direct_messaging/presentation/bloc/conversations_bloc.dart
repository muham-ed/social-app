import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/entities/conversation.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();
  @override
  List<Object?> get props => [];
}

class ConversationsLoad extends ConversationsEvent {
  const ConversationsLoad();
}

abstract class ConversationsState extends Equatable {
  const ConversationsState();
  @override
  List<Object?> get props => [];
}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsLoaded extends ConversationsState {
  final List<Conversation> items;
  const ConversationsLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class ConversationsError extends ConversationsState {
  final String message;
  const ConversationsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final MessageRepository _repo;

  ConversationsBloc(this._repo) : super(ConversationsInitial()) {
    on<ConversationsLoad>((event, emit) async {
      emit(ConversationsLoading());
      final res = await _repo.listConversations();
      res.fold(
        (f) => emit(ConversationsError(f.message)),
        (items) => emit(ConversationsLoaded(items)),
      );
    });
  }
}