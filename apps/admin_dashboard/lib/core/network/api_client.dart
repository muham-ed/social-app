import 'package:dio/dio.dart';
import 'dart:io';

class ApiClient {
  late final Dio _dio;
  final String _baseUrl = 'http://localhost:5000/api/v1'; // Adjust for your environment

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) => _dio.get(path, queryParameters: query);
  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) => _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}
