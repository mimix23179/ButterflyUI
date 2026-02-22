import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/webview/webview.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildHtmlViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final html = (props['html'] ?? props['value'] ?? props['text'] ?? '').toString();
  final webviewProps = <String, Object?>{
    ...props,
    'html': html,
    if (props['url'] == null) 'url': '',
  };

  final child = buildWebViewControl(
    controlId,
    webviewProps,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );

  final fixedHeight = coerceDouble(props['height']);
  if (fixedHeight != null) {
    return SizedBox(height: fixedHeight, child: child);
  }
  return child;
}
