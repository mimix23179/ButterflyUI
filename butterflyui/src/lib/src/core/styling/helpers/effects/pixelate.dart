import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPixelateControl(
  String controlId,
  Map<String, Object?> props,
  Widget child, {
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
        controlType: 'pixelate',
      );
      final enabled = effective['enabled'] == null
          ? true
          : (effective['enabled'] == true);
      if (!enabled) return child;
      final amount = (coerceDouble(effective['amount']) ?? 0.35).clamp(
        0.0,
        1.0,
      );
      final downscale = (1.0 - (amount * 0.9)).clamp(0.1, 1.0);

      final built = ClipRect(
        child: Transform.scale(
          scale: 1 / downscale,
          alignment: Alignment.center,
          filterQuality: FilterQuality.none,
          child: Transform.scale(
            scale: downscale,
            alignment: Alignment.center,
            filterQuality: FilterQuality.none,
            child: child,
          ),
        ),
      );
      return wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty ? 'pixelate::layers' : '$controlId::layers',
        props: effective,
        child: built,
      );
    },
  );
}
