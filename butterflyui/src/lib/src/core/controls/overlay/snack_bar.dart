import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/feedback/toast.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSnackBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildToastOverlayControl(
    controlId,
    <String, Object?>{...props, 'style': props['style'] ?? 'snackbar'},
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
    defaultStyle: 'snackbar',
  );
}
