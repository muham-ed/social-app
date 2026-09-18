import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? description,
  });

  Future<Either<Failure, void>> blockUser(String userId);
}
