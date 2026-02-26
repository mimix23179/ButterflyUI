import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/navigation/status_bar.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildInfoBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildStatusBarControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
