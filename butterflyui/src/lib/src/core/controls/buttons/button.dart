import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildButtonControl(
  String? controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final resolvedId = controlId ?? '';
  final rawVariant =
      (props['variant']?.toString() ??
              tokens.string('button', 'variant') ??
              'elevated')
          .toLowerCase()
          .trim();
  final variant = rawVariant.isEmpty ? 'elevated' : rawVariant;
  return buildButtonVariantControl(
    controlId: resolvedId,
    props: props,
    tokens: tokens,
    variant: variant,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
