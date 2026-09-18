import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';

abstract class RoomRepository {
  Future<Either<Failure, List<Room>>> list({int page});
  Future<Either<Failure, Room>> create({required String title, String? description, String type});
  Future<Either<Failure, void>> join(String id);
  Future<Either<Failure, void>> leave(String id);
  Future<Either<Failure, Map<String, dynamic>>> token(String id, {String role});
  Future<Either<Failure, void>> close(String id);
}