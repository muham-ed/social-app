import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/token_storage.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _client;
  final TokenStorage _storage;
  AuthRemoteDataSource(this._client, this._storage);

  Future<UserModel> login({required String emailOrUsername, required String password}) async {
    try {
      final res = await _client.post('/auth/login', data: {
        'emailOrUsername': emailOrUsername,
        'password': password,
      });
      final data = res.data['data'];
      await _storage.saveTokens(
        access: data['tokens']['access'],
        refresh: data['tokens']['refresh'],
      );
      return UserModel.fromJson(data['user']);
    } catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  Future<UserModel> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.post('/auth/register', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      });
      final data = res.data['data'];
      await _storage.saveTokens(
        access: data['tokens']['access'],
        refresh: data['tokens']['refresh'],
      );
      return UserModel.fromJson(data['user']);
    } catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final res = await _client.get('/auth/me');
      return UserModel.fromJson(res.data['data']);
    } catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  Future<void> logout() async {
    try {
      await _client.post('/auth/logout');
    } catch (_) {}
    await _storage.clear();
  }

  String _extractMessage(dynamic e) {
    try {
      final dynamic data = (e as dynamic).response?.data;
      if (data is Map && data['message'] != null) return data['message'];
    } catch (_) {}
    return 'حدث خطأ غير متوقع';
  }
}