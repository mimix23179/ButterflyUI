import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/customization/histogram_view.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildHistogramOverlayControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final resolved = resolveStylingHelperProps(
    props,
    controlType: 'histogram_overlay',
  );
  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  final histogram = buildHistogramViewControl(
    controlId,
    resolved,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );

  final opacity = (coerceDouble(resolved['opacity']) ?? 0.45).clamp(0.0, 1.0);

  return wrapWithEffectRenderLayers(
    controlId: controlId.isEmpty
        ? 'histogram_overlay::layers'
        : '$controlId::layers',
    props: resolved,
    child: Stack(
    fit: StackFit.passthrough,
    children: [
      child,
      IgnorePointer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(opacity: opacity, child: histogram),
        ),
      ),
    ],
    ),
  );
}
