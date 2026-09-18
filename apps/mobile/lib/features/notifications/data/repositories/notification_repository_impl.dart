import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;
  NotificationRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> list({int page = 1}) async {
    try {
      return Right(await _remote.list(page: page));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markRead(String id) async {
    try {
      await _remote.markRead(id);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAll() async {
    try {
      await _remote.markAll();
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> registerToken(String token) async {
    try {
      await _remote.registerToken(token);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
