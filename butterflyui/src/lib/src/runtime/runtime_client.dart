import 'dart:async';

import 'protocol/message.dart';
import 'transport/transport.dart';
import 'frame_pacer.dart';

class RuntimeClient {
  final RuntimeTransport transport;
  final int protocol;

  RuntimeClient({required this.transport, this.protocol = 1});

  Stream<RuntimeMessage> get messages => transport.messages;

  Future<RuntimeMessage> connectAndHello({String? appId, String? token}) async {
    await transport.connect();
    final hello = RuntimeMessage(
      type: 'runtime.hello',
      payload: {
        'protocol': protocol,
        if (appId != null) 'app_id': appId,
        if (token != null) 'token': token,
      },
      id: DateTime.now().microsecondsSinceEpoch.toString(),
    );
    await transport.send(hello);
    final ack = await transport.messages
        .firstWhere((msg) => msg.type == 'runtime.hello_ack')
        .timeout(const Duration(seconds: 10));

    final fpsRaw = ack.payload['target_fps'];
    if (fpsRaw is num) {
      framePacer.setTargetFps(fpsRaw.toInt());
    } else if (fpsRaw is String) {
      final parsed = int.tryParse(fpsRaw);
      if (parsed != null) {
        framePacer.setTargetFps(parsed);
      }
    }

    return ack;
  }

  Future<void> disconnect() => transport.disconnect();

  Future<void> send(RuntimeMessage message) => transport.send(message);
}
