import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource _remote;
  RoomRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Room>>> list({int page = 1}) async {
    try {
      return Right(await _remote.list(page: page));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Room>> create({required String title, String? description, String type = 'audio'}) async {
    try {
      return Right(await _remote.create(title: title, description: description, type: type));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> join(String id) async {
    try {
      await _remote.join(id);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> leave(String id) async {
    try {
      await _remote.leave(id);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> token(String id, {String role = 'publisher'}) async {
    try {
      return Right(await _remote.token(id, role: role));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> close(String id) async {
    try {
      await _remote.close(id);
      return const Right(null);
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
