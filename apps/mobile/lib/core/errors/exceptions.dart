class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException(this.message, {this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'فشل الاتصال بالشبكة']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'فشل قراءة البيانات من الذاكرة']);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
}