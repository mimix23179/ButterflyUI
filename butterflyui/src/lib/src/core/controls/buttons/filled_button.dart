import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFilledButtonControl(
  String controlId,
  Map<String, Object?> props,
  StylingTokens tokens,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonVariantControl(
    controlId: controlId,
    props: <String, Object?>{'variant': 'filled', ...props},
    tokens: tokens,
    variant: 'filled',
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
