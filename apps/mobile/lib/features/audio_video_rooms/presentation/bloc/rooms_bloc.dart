import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();
  @override
  List<Object?> get props => [];
}
class RoomsLoad extends RoomsEvent {
  const RoomsLoad();
}
class RoomCreate extends RoomsEvent {
  final String title;
  final String type;
  const RoomCreate(this.title, this.type);
  @override
  List<Object?> get props => [title, type];
}

abstract class RoomsState extends Equatable {
  const RoomsState();
  @override
  List<Object?> get props => [];
}
class RoomsInitial extends RoomsState {}
class RoomsLoading extends RoomsState {}
class RoomsLoaded extends RoomsState {
  final List<Room> rooms;
  const RoomsLoaded(this.rooms);
  @override
  List<Object?> get props => [rooms];
}
class RoomsError extends RoomsState {
  final String message;
  const RoomsError(this.message);
}

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final RoomRepository _repo;
  RoomsBloc(this._repo) : super(RoomsInitial()) {
    on<RoomsLoad>(_onLoad);
    on<RoomCreate>(_onCreate);
  }

  Future<void> _onLoad(RoomsLoad event, Emitter<RoomsState> emit) async {
    emit(RoomsLoading());
    final res = await _repo.list();
    res.fold((f) => emit(RoomsError(f.message)), (rooms) => emit(RoomsLoaded(rooms)));
  }

  Future<void> _onCreate(RoomCreate event, Emitter<RoomsState> emit) async {
    emit(RoomsLoading());
    final res = await _repo.create(title: event.title, type: event.type);
    res.fold((f) => emit(RoomsError(f.message)), (_) => add(const RoomsLoad()));
  }
}
