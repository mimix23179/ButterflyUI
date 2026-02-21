import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildWebViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final webProps = ButterflyUIWebViewProps.fromJson(coerceObjectMap(props));
  return ButterflyUIWebViewWidget(
    controlId: controlId,
    props: webProps,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

