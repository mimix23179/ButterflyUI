import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOutlinedButtonControl(
  String controlId,
  Map<String, Object?> props,
  StylingTokens tokens,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonVariantControl(
    controlId: controlId,
    props: <String, Object?>{'variant': 'outlined', ...props},
    tokens: tokens,
    variant: 'outlined',
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
