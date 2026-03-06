import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonVariantControl(
    controlId: controlId,
    props: <String, Object?>{'variant': 'icon_button', ...props},
    tokens: tokens,
    variant: 'icon_button',
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
