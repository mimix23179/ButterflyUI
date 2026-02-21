import 'package:flutter/material.dart';

import 'candy/theme.dart';
import 'style/style_pack.dart';
import 'webview/webview_api.dart';
import 'control_utils.dart';

typedef ButterflyUIControlBuilder = Widget Function(
  ButterflyUIControlContext context,
  Map<String, Object?> control,
);

class ButterflyUIControlContext {
  final CandyTokens tokens;
  final StylePack stylePack;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUISendRuntimeSystemEvent sendSystemEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget Function(Map<String, Object?> control) buildChild;

  const ButterflyUIControlContext({
    required this.tokens,
    required this.stylePack,
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

class ButterflyUIControlRegistry {
  final Map<String, ButterflyUIControlBuilder> _builders = {};

  void register(String type, ButterflyUIControlBuilder builder) {
    _builders[type] = builder;
  }

  ButterflyUIControlBuilder? builderFor(String type) {
    return _builders[type];
  }

  bool has(String type) => _builders.containsKey(type);
}


