import 'dart:async';

import 'package:web_socket_channel/html.dart';
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
    final socket = HtmlWebSocketChannel.connect(uri);
    _socket = socket;
    final completer = Completer<void>();

    socket.stream.listen(
      (dynamic data) {
        if (data is String) {
          try {
            _controller.add(decodeMessage(data));
          } catch (_) {}
        }
      },
      onDone: () => _controller.close(),
      onError: (_) => _controller.close(),
      cancelOnError: true,
    );

    socket.ready.then((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }).catchError((_) {
      if (!completer.isCompleted) {
        completer.completeError(StateError('WebSocket connection failed'));
      }
    });

    return completer.future;
  }

  @override
  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    await socket?.sink.close();
  }

  @override
  Future<void> send(RuntimeMessage message) async {
    final socket = _socket;
    if (socket == null) return;
    socket.sink.add(encodeMessage(message));
  }
}
