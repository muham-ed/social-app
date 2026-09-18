class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api/v1',
  );
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );
  static const String uploadsUrl = String.fromEnvironment(
    'UPLOADS_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );
  static const String agoraAppId = String.fromEnvironment('AGORA_APP_ID', defaultValue: '');
}