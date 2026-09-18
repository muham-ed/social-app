import '../../../../core/network/api_client.dart';
import '../models/room_model.dart';

class RoomRemoteDataSource {
  final ApiClient _client;
  RoomRemoteDataSource(this._client);

  Future<List<RoomModel>> list({int page = 1}) async {
    final res = await _client.get('/rooms', query: {'page': page});
    final list = (res.data['data']['rooms'] as List).cast<Map<String, dynamic>>();
    return list.map(RoomModel.fromJson).toList();
  }

  Future<RoomModel> create({required String title, String? description, String type = 'audio'}) async {
    final res = await _client.post('/rooms', data: {
      'title': title,
      'description': description ?? '',
      'type': type,
    });
    return RoomModel.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> join(String id) async {
    final res = await _client.post('/rooms/$id/join');
    return res.data['data'];
  }

  Future<void> leave(String id) => _client.post('/rooms/$id/leave');

  Future<Map<String, dynamic>> token(String id, {String role = 'publisher'}) async {
    final res = await _client.get('/rooms/$id/token', query: {'role': role});
    return res.data['data'];
  }

  Future<void> close(String id) => _client.post('/rooms/$id/close');
}