import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource _remote;
  VideoRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Video>>> getFeed({int page = 1, int limit = 20}) async {
    try {
      final list = await _remote.getFeed(page: page, limit: limit);
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Video>> getById(String id) async {
    try {
      return Right(await _remote.getById(id));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}