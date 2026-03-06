import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/flex_spacer.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSpacerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildFlexSpacerControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
