import 'package:flutter/material.dart';

import 'candy/theme.dart';
import 'style/style_pack.dart';
import 'webview/webview_api.dart';
import 'runtime_control_node.dart';

typedef ButterflyUIControlBuilder =
    Widget Function(
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
    return nodeOf(control).props;
  }

  List<Map<String, Object?>> childMapsOf(Map<String, Object?> control) {
    return nodeOf(control).children;
  }

  RuntimeControlNode nodeOf(Map<String, Object?> control) {
    return RuntimeControlNode(control);
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
