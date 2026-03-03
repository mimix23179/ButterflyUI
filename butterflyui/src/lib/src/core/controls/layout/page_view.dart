import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/view_stack.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPageViewControl(
  String controlId,
  Map<String, Object?> props,
  List<Widget> children,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final merged = <String, Object?>{...props};
  merged.putIfAbsent('animate', () => true);
  return buildViewStackControl(
    controlId,
    merged,
    children,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
