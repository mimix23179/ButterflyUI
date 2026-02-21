import 'package:flutter/material.dart';

import 'candy/theme.dart';
import 'webview/webview_api.dart';
import 'control_utils.dart';

typedef ConduitControlBuilder = Widget Function(
  ConduitControlContext context,
  Map<String, Object?> control,
);

class ConduitControlContext {
  final CandyTokens tokens;
  final ConduitSendRuntimeEvent sendEvent;
  final ConduitSendRuntimeSystemEvent sendSystemEvent;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget Function(Map<String, Object?> control) buildChild;

  const ConduitControlContext({
    required this.tokens,
    required this.sendEvent,
    required this.sendSystemEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.buildChild,
  });

  Map<String, Object?> propsOf(Map<String, Object?> control) {
    final raw = control['props'];
    if (raw is Map) return coerceObjectMap(raw);
    return <String, Object?>{};
  }

  List<Map<String, Object?>> childMapsOf(Map<String, Object?> control) {
    final raw = control['children'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((c) => coerceObjectMap(c))
        .toList();
  }
}

class ConduitControlRegistry {
  final Map<String, ConduitControlBuilder> _builders = {};

  void register(String type, ConduitControlBuilder builder) {
    _builders[type] = builder;
  }

  ConduitControlBuilder? builderFor(String type) {
    return _builders[type];
  }

  bool has(String type) => _builders.containsKey(type);
}


