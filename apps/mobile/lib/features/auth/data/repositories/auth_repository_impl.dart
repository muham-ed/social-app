import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/websocket_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final WebSocketClient _ws;
  AuthRepositoryImpl(this._remote, this._ws);

  @override
  Future<Either<Failure, User>> login({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final user = await _remote.login(emailOrUsername: emailOrUsername, password: password);
      await _ws.connect();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.register(
        name: name,
        username: username,
        email: email,
        password: password,
      );
      await _ws.connect();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _remote.getCurrentUser();
      await _ws.connect();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('الجلسة منتهية'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _remote.logout();
    _ws.disconnect();
    return const Right(null);
  }
}