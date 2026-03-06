import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFrameControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildContainerControl(
    controlId,
    props,
    rawChildren,
    buildFromControl,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
