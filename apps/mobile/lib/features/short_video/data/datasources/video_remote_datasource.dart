import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/video_model.dart';

class VideoRemoteDataSource {
  final ApiClient _client;
  VideoRemoteDataSource(this._client);

  Future<List<VideoModel>> getFeed({int page = 1, int limit = 20}) async {
    final res = await _client.get('/videos/feed', query: {'page': page, 'limit': limit});
    final list = (res.data['data']['videos'] as List).cast<Map<String, dynamic>>();
    return list.map(VideoModel.fromJson).toList();
  }

  Future<VideoModel> getById(String id) async {
    final res = await _client.get('/videos/$id');
    return VideoModel.fromJson(res.data['data']);
  }

  Future<void> delete(String id) => _client.delete('/videos/$id');

  Future<VideoModel> uploadVideo({
    required String filePath,
    required String caption,
  }) async {
    final formData = FormData.fromMap({
      'caption': caption,
      'video': await MultipartFile.fromFile(filePath, filename: 'video.mp4'),
    });
    final res = await _client.post('/videos', data: formData);
    return VideoModel.fromJson(res.data['data']);
  }
}