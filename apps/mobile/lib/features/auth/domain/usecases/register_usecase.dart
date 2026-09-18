import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<Either<Failure, User>> call({
    required String name,
    required String username,
    required String email,
    required String password,
  }) {
    return _repo.register(name: name, username: username, email: email, password: password);
  }
}