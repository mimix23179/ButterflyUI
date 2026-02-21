import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../protocol/codec.dart';
import '../protocol/message.dart';
import 'transport.dart';

class WebSocketRuntimeTransport implements RuntimeTransport {
  final Uri uri;
  WebSocketChannel? _socket;
  final StreamController<RuntimeMessage> _controller =
      StreamController<RuntimeMessage>.broadcast();

  WebSocketRuntimeTransport(this.uri);

  @override
  Stream<RuntimeMessage> get messages => _controller.stream;

  @override
  Future<void> connect() async {
    if (_socket != null) return;
    _socket = IOWebSocketChannel.connect(uri);
    _socket!.stream.listen(
      (dynamic data) {
        if (data is String) {
          try {
            _controller.add(decodeMessage(data));
          } catch (_) {
            // Ignore malformed message
          }
        }
      },
      onDone: () => _controller.close(),
      onError: (_) => _controller.close(),
      cancelOnError: true,
    );
  }

  @override
  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    if (socket != null) {
      await socket.sink.close();
    }
  }

  @override
  Future<void> send(RuntimeMessage message) async {
    final socket = _socket;
    if (socket == null) return;
    socket.sink.add(encodeMessage(message));
  }
}
