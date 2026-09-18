import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> list({int page});
  Future<Either<Failure, void>> markRead(String id);
  Future<Either<Failure, void>> markAll();
  Future<Either<Failure, void>> registerToken(String token);
}
