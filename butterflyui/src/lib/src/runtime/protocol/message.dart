class RuntimeMessage {
  final String type;
  final Map<String, Object?> payload;
  final String? id;
  final String? replyTo;

  const RuntimeMessage({
    required this.type,
    this.payload = const {},
    this.id,
    this.replyTo,
  });

  Map<String, Object?> toJson() {
    final data = <String, Object?>{
      'type': type,
      'payload': payload,
    };
    if (id != null) data['id'] = id;
    if (replyTo != null) data['reply_to'] = replyTo;
    return data;
  }

  factory RuntimeMessage.fromJson(Map<String, Object?> data) {
    final rawType = data['type']?.toString();
    if (rawType == null || rawType.isEmpty) {
      throw ArgumentError('runtime message requires a type');
    }
    final payloadRaw = data['payload'];
    Map<String, Object?> payload = const {};
    if (payloadRaw is Map) {
      payload = payloadRaw.map((key, value) => MapEntry(key.toString(), value));
    }
    return RuntimeMessage(
      type: rawType,
      payload: payload,
      id: data['id']?.toString(),
      replyTo: data['reply_to']?.toString(),
    );
  }
}