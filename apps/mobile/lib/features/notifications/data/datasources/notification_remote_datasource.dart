import '../../../../core/network/api_client.dart';

class NotificationRemoteDataSource {
  final ApiClient _client;
  NotificationRemoteDataSource(this._client);

  Future<List<Map<String, dynamic>>> list({int page = 1}) async {
    final res = await _client.get('/notifications', query: {'page': page});
    return (res.data['data']['notifications'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> markRead(String id) => _client.post('/notifications/$id/read');
  Future<void> markAll() => _client.post('/notifications/read-all');
  Future<void> registerToken(String token) => _client.post('/notifications/token', data: {'token': token});
}
