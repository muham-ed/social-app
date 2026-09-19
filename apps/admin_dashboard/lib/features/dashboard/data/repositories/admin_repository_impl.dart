import '../../../core/network/api_client.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final ApiClient _client;
  AdminRepositoryImpl(this._client);

  @override
  Future<Map<String, dynamic>> getStats() async {
    final res = await _client.get('/admin/stats');
    return res.data['data'];
  }

  @override
  Future<List<Map<String, dynamic>>> listUsers() async {
    final res = await _client.get('/admin/users');
    return (res.data['data'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> toggleUserBan(String userId) => _client.post('/admin/users/$userId/toggle-ban');

  @override
  Future<List<Map<String, dynamic>>> listReports() async {
    final res = await _client.get('/reports');
    return (res.data['data']['reports'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> handleReport(String reportId, String status) => _client.post('/reports/$reportId/handle', data: {'status': status});

  @override
  Future<List<Map<String, dynamic>>> listActiveRooms() async {
    final res = await _client.get('/admin/rooms/active');
    return (res.data['data'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> closeRoom(String roomId) => _client.post('/rooms/$roomId/close');

  @override
  Future<List<Map<String, dynamic>>> listVideos() async {
    final res = await _client.get('/admin/videos');
    return (res.data['data'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> deleteVideo(String videoId) => _client.delete('/videos/$videoId');

  @override
  Future<void> sendGlobalNotification(String title, String body) => _client.post('/admin/notifications/global', data: {'title': title, 'body': body});
}
