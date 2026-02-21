import 'dart:convert';

import 'message.dart';

String encodeMessage(RuntimeMessage message) {
  return jsonEncode(message.toJson());
}

RuntimeMessage decodeMessage(String raw) {
  final data = jsonDecode(raw);
  if (data is! Map) {
    throw ArgumentError('runtime message must be a JSON object');
  }
  return RuntimeMessage.fromJson(data.cast<String, Object?>());
}