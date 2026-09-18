import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/report_repository.dart';

abstract class ReportBlockEvent extends Equatable {
  const ReportBlockEvent();
  @override
  List<Object?> get props => [];
}

class SubmitReportEvent extends ReportBlockEvent {
  final String targetType;
  final String targetId;
  final String reason;
  final String? description;

  const SubmitReportEvent({
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.description,
  });

  @override
  List<Object?> get props => [targetType, targetId, reason, description];
}

class SubmitBlockEvent extends ReportBlockEvent {
  final String userId;
  const SubmitBlockEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

abstract class ReportBlockState extends Equatable {
  const ReportBlockState();
  @override
  List<Object?> get props => [];
}

class ReportBlockInitial extends ReportBlockState {}
class ReportBlockLoading extends ReportBlockState {}
class ReportSuccessState extends ReportBlockState {}
class BlockSuccessState extends ReportBlockState {}
class ReportBlockError extends ReportBlockState {
  final String message;
  const ReportBlockError(this.message);
  @override
  List<Object?> get props => [message];
}

class ReportBlockBloc extends Bloc<ReportBlockEvent, ReportBlockState> {
  final ReportRepository _repo;

  ReportBlockBloc(this._repo) : super(ReportBlockInitial()) {
    on<SubmitReportEvent>((event, emit) async {
      emit(ReportBlockLoading());
      final res = await _repo.report(
        targetType: event.targetType,
        targetId: event.targetId,
        reason: event.reason,
        description: event.description,
      );
      res.fold(
        (f) => emit(ReportBlockError(f.message)),
        (_) => emit(ReportSuccessState()),
      );
    });

    on<SubmitBlockEvent>((event, emit) async {
      emit(ReportBlockLoading());
      final res = await _repo.blockUser(event.userId);
      res.fold(
        (f) => emit(ReportBlockError(f.message)),
        (_) => emit(BlockSuccessState()),
      );
    });
  }
}
