import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/discover_repository.dart';
import '../datasources/discover_remote_datasource.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final DiscoverRemoteDataSource _remote;
  DiscoverRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<User>>> nearby({
    required double lng,
    required double lat,
    double radiusKm = 10,
    String? query,
  }) async {
    try {
      return Right(await _remote.nearby(lng: lng, lat: lat, radiusKm: radiusKm, query: query));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
