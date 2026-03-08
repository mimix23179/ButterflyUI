import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildShadowControl(
  Map<String, Object?> props,
  Widget child, {
  String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
}) {
  return buildRuntimePropsControl(
    props: props,
    controlId: controlId,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    builder: (liveProps) {
      final radius = coerceDouble(liveProps['radius']) ?? 0.0;
      final configured = coerceBoxShadow(liveProps['shadows']);
      final shadowColor =
          coerceColor(liveProps['color']) ?? const Color(0x33000000);
      final blur = coerceDouble(liveProps['blur']) ?? 12.0;
      final spread = coerceDouble(liveProps['spread']) ?? 0.0;
      final offsetX = coerceDouble(liveProps['offset_x']) ?? 0.0;
      final offsetY = coerceDouble(liveProps['offset_y']) ?? 4.0;
      final shadows =
          configured ??
          <BoxShadow>[
            BoxShadow(
              color: shadowColor,
              blurRadius: blur,
              spreadRadius: spread,
              offset: Offset(offsetX, offsetY),
            ),
          ];

      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius <= 0 ? null : BorderRadius.circular(radius),
          boxShadow: shadows,
        ),
        child: child,
      );
    },
  );
}
