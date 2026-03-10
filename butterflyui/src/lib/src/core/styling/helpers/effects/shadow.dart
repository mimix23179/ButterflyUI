import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
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
      final effective = resolveStylingHelperProps(
        liveProps,
        controlType: 'shadow',
      );
      final radius = coerceDouble(effective['radius']) ?? 0.0;
      final configured = coerceBoxShadow(effective['shadows']);
      final shadowColor =
          coerceColor(effective['color']) ?? const Color(0x33000000);
      final blur = coerceDouble(effective['blur']) ?? 12.0;
      final spread = coerceDouble(effective['spread']) ?? 0.0;
      final offsetX = coerceDouble(effective['offset_x']) ?? 0.0;
      final offsetY = coerceDouble(effective['offset_y']) ?? 4.0;
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

      final built = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius <= 0 ? null : BorderRadius.circular(radius),
          boxShadow: shadows,
        ),
        child: child,
      );
      return wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty ? 'shadow::layers' : '$controlId::layers',
        props: effective,
        child: built,
      );
    },
  );
}
