import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/video_repository.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
  @override
  List<Object?> get props => [];
}
class FeedLoadRequested extends FeedEvent {
  final bool refresh;
  const FeedLoadRequested({this.refresh = false});
  @override
  List<Object?> get props => [refresh];
}
class FeedLoadMore extends FeedEvent {}

abstract class FeedState extends Equatable {
  const FeedState();
  @override
  List<Object?> get props => [];
}
class FeedInitial extends FeedState {}
class FeedLoading extends FeedState {}
class FeedLoaded extends FeedState {
  final List<Video> videos;
  final bool hasMore;
  const FeedLoaded(this.videos, {this.hasMore = true});
  @override
  List<Object?> get props => [videos, hasMore];
}
class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final VideoRepository _repo;
  int _page = 1;

  FeedBloc(this._repo) : super(FeedInitial()) {
    on<FeedLoadRequested>(_onLoad);
    on<FeedLoadMore>(_onMore);
  }

  Future<void> _onLoad(FeedLoadRequested event, Emitter<FeedState> emit) async {
    if (event.refresh) _page = 1;
    emit(FeedLoading());
    final result = await _repo.getFeed(page: _page);
    result.fold(
      (f) => emit(FeedError(f.message)),
      (videos) => emit(FeedLoaded(videos, hasMore: videos.length >= 20)),
    );
  }

  Future<void> _onMore(FeedLoadMore event, Emitter<FeedState> emit) async {
    final current = state;
    if (current is! FeedLoaded || !current.hasMore) return;
    _page++;
    final result = await _repo.getFeed(page: _page);
    result.fold(
      (_) {},
      (videos) => emit(FeedLoaded([...current.videos, ...videos], hasMore: videos.length >= 20)),
    );
  }
}