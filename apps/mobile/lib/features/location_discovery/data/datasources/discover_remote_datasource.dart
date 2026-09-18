import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

class DiscoverRemoteDataSource {
  final ApiClient _client;
  DiscoverRemoteDataSource(this._client);

  Future<List<UserModel>> nearby({
    required double lng,
    required double lat,
    double radiusKm = 10,
    String? query,
  }) async {
    final res = await _client.get('/users/discover', query: {
      'lng': lng,
      'lat': lat,
      'radiusKm': radiusKm,
      if (query != null) 'query': query,
    });
    return (res.data['data'] as List).map((e) => UserModel.fromJson(e)).toList();
  }
}
