import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Video extends Equatable {
  final String id;
  final User author;
  final String caption;
  final String videoUrl;
  final String thumbnailUrl;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final List<String> hashtags;

  const Video({
    required this.id,
    required this.author,
    required this.videoUrl,
    this.caption = '',
    this.thumbnailUrl = '',
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.hashtags = const [],
  });

  @override
  List<Object?> get props => [id, videoUrl, likesCount];
}