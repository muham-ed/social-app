import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<Either<Failure, User>> call({required String emailOrUsername, required String password}) {
    return _repo.login(emailOrUsername: emailOrUsername, password: password);
  }
}