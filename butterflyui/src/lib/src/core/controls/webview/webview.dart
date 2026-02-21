import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview.dart';
import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildWebViewControl(
  String controlId,
  Map<String, Object?> props,
  ConduitRegisterInvokeHandler registerInvokeHandler,
  ConduitUnregisterInvokeHandler unregisterInvokeHandler,
  ConduitSendRuntimeEvent sendEvent,
) {
  final webProps = ConduitWebViewProps.fromJson(coerceObjectMap(props));
  return ConduitWebViewWidget(
    controlId: controlId,
    props: webProps,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

