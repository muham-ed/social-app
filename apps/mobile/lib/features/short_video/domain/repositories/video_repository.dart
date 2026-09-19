import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<Video>>> getFeed({int page, int limit});
  Future<Either<Failure, Video>> getById(String id);
  Future<Either<Failure, void>> delete(String id);
  Future<Either<Failure, Video>> uploadVideo({
    required String filePath,
    required String caption,
  });
}