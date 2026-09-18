import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class DiscoverRepository {
  Future<Either<Failure, List<User>>> nearby({required double lng, required double lat, double radiusKm, String? query});
}
