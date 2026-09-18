import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/location_service.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/discover_repository.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();
  @override
  List<Object?> get props => [];
}
class DiscoverLoad extends DiscoverEvent {
  final double? radiusKm;
  final String? query;
  const DiscoverLoad({this.radiusKm = 10, this.query});
  @override
  List<Object?> get props => [radiusKm, query];
}

abstract class DiscoverState extends Equatable {
  const DiscoverState();
  @override
  List<Object?> get props => [];
}
class DiscoverInitial extends DiscoverState {}
class DiscoverLoading extends DiscoverState {}
class DiscoverLoaded extends DiscoverState {
  final List<User> users;
  const DiscoverLoaded(this.users);
  @override
  List<Object?> get props => [users];
}
class DiscoverError extends DiscoverState {
  final String message;
  const DiscoverError(this.message);
  @override
  List<Object?> get props => [message];
}

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository _repo;
  final LocationService _location;
  DiscoverBloc(this._repo, this._location) : super(DiscoverInitial()) {
    on<DiscoverLoad>(_onLoad);
  }

  Future<void> _onLoad(DiscoverLoad event, Emitter<DiscoverState> emit) async {
    emit(DiscoverLoading());
    final pos = await _location.getCurrentPosition();
    if (pos == null) {
      emit(const DiscoverError('يرجى السماح بالوصول للموقع'));
      return;
    }
    final res = await _repo.nearby(
      lng: pos.longitude,
      lat: pos.latitude,
      radiusKm: event.radiusKm ?? 10,
      query: event.query,
    );
    res.fold(
      (f) => emit(DiscoverError(f.message)),
      (users) => emit(DiscoverLoaded(users)),
    );
  }
}
