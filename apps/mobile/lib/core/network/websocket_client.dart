import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/env.dart';
import 'token_storage.dart';

class WebSocketClient {
  final TokenStorage _tokenStorage;
  io.Socket? _socket;

  WebSocketClient(this._tokenStorage);

  Future<io.Socket> connect() async {
    if (_socket != null && _socket!.connected) return _socket!;
    final token = await _tokenStorage.accessToken;
    _socket = io.io(
      Env.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );
    _socket!.connect();
    return _socket!;
  }

  io.Socket? get socket => _socket;
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}