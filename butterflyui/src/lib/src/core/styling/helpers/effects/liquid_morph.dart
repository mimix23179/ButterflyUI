import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildLiquidMorphControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild, {
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
        controlType: 'liquid_morph',
      );
      Widget child = const SizedBox.shrink();
      for (final raw in rawChildren) {
        if (raw is Map) {
          child = buildChild(coerceObjectMap(raw));
          break;
        }
      }

      final minRadius = coerceDouble(effective['min_radius']) ?? 8;
      final maxRadius = coerceDouble(effective['max_radius']) ?? 24;
      final animate = effective['animate'] != false;
      final durationMs = (coerceOptionalInt(effective['duration_ms']) ?? 1200)
          .clamp(1, 600000);
      final targetRadius = animate ? maxRadius : minRadius;

      final built = AnimatedContainer(
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(math.max(0, targetRadius)),
        ),
        child: child,
      );
      return wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty
            ? 'liquid_morph::layers'
            : '$controlId::layers',
        props: effective,
        child: built,
      );
    },
  );
}
