import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/display/canvas_control.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRuntimeCanvasControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildCanvasControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
