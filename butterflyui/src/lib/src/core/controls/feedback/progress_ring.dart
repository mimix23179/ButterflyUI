import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/feedback/progress_indicator.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressRingControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final merged = <String, Object?>{...props};
  merged.putIfAbsent('variant', () => 'circular');
  merged.putIfAbsent('circular', () => true);
  return buildProgressIndicatorControl(
    controlId,
    merged,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
