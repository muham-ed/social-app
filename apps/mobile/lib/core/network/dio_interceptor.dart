import 'package:dio/dio.dart';
import '../config/env.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._tokenStorage, this._dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refresh = await _tokenStorage.refreshToken;
        if (refresh == null) throw Exception('لا يوجد refresh token');

        final response = await Dio().post(
          '${Env.apiBaseUrl}/auth/refresh',
          data: {'refreshToken': refresh},
        );
        final data = response.data['data'];
        await _tokenStorage.saveTokens(
          access: data['access'],
          refresh: data['refresh'],
        );
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${data['access']}';
        final retry = await _dio.fetch(opts);
        _isRefreshing = false;
        return handler.resolve(retry);
      } catch (_) {
        _isRefreshing = false;
        await _tokenStorage.clear();
      }
    }
    handler.next(err);
  }
}