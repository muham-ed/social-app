import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient _client;
  ReportRepositoryImpl(this._client);

  @override
  Future<Either<Failure, void>> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? description,
  }) async {
    try {
      await _client.post('/reports', data: {
        'targetType': targetType,
        'targetId': targetId,
        'reason': reason,
        'description': description,
      });
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('فشل إرسال البلاغ'));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser(String userId) async {
    try {
      await _client.post('/users/block/$userId');
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('فشل حظر المستخدم'));
    }
  }
}
