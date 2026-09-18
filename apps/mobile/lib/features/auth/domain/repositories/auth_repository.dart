import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String emailOrUsername, required String password});
  Future<Either<Failure, User>> register({
    required String name,
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> logout();
}