import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/notification_repository.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}
class NotificationsLoad extends NotificationsEvent {
  const NotificationsLoad();
}
class NotificationMarkRead extends NotificationsEvent {
  final String id;
  const NotificationMarkRead(this.id);
  @override
  List<Object?> get props => [id];
}
class NotificationsMarkAll extends NotificationsEvent {
  const NotificationsMarkAll();
}

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}
class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}
class NotificationsLoaded extends NotificationsState {
  final List<Map<String, dynamic>> items;
  const NotificationsLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _repo;
  NotificationsBloc(this._repo) : super(NotificationsInitial()) {
    on<NotificationsLoad>(_onLoad);
    on<NotificationMarkRead>(_onRead);
    on<NotificationsMarkAll>(_onAll);
  }

  Future<void> _onLoad(NotificationsLoad event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    final res = await _repo.list();
    res.fold((f) => emit(NotificationsError(f.message)), (list) => emit(NotificationsLoaded(list)));
  }

  Future<void> _onRead(NotificationMarkRead event, Emitter<NotificationsState> emit) async {
    await _repo.markRead(event.id);
    add(const NotificationsLoad());
  }

  Future<void> _onAll(NotificationsMarkAll event, Emitter<NotificationsState> emit) async {
    await _repo.markAll();
    add(const NotificationsLoad());
  }
}
