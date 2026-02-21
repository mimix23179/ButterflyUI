import 'package:flutter/foundation.dart';

class TracebackLogger {
  static final Set<String> _seen = <String>{};

  static void logOnce({
    required String? title,
    required String? traceback,
  }) {
    if (traceback == null || traceback.trim().isEmpty) return;
    final key = '${title ?? ''}\n$traceback';
    if (_seen.contains(key)) return;
    _seen.add(key);
    debugPrint('ButterflyUI runtime problem: ${title ?? 'Error'}\n$traceback');
  }
}
