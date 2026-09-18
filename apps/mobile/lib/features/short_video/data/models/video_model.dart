import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.author,
    required super.videoUrl,
    super.caption,
    super.thumbnailUrl,
    super.likesCount,
    super.commentsCount,
    super.sharesCount,
    super.viewsCount,
    super.hashtags,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      author: UserModel.fromJson(json['author'] ?? {}),
      videoUrl: json['videoUrl'] ?? '',
      caption: json['caption'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      viewsCount: json['viewsCount'] ?? 0,
      hashtags: (json['hashtags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}