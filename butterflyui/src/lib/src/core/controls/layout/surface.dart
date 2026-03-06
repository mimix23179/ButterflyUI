import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSurfaceControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildContainerControl(
    controlId,
    props,
    rawChildren,
    buildChild,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
