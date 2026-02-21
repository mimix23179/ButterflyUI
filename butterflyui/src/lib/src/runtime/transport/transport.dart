import '../protocol/message.dart';

abstract class RuntimeTransport {
  Stream<RuntimeMessage> get messages;
  Future<void> connect();
  Future<void> disconnect();
  Future<void> send(RuntimeMessage message);
}