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
}