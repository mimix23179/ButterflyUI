import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/histogram_view.dart';
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
  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  final histogram = buildHistogramViewControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );

  final opacity = (coerceDouble(props['opacity']) ?? 0.45).clamp(0.0, 1.0);

  return Stack(
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
  );
}
