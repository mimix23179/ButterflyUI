import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGestureAreaControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final tapEnabled = props['tap_enabled'] == null || props['tap_enabled'] == true;
  final doubleTapEnabled = props['double_tap_enabled'] == true;
  final longPressEnabled = props['long_press_enabled'] == true;
  final panEnabled = props['pan_enabled'] == true;
  final scaleEnabled = props['scale_enabled'] == true;

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  void emit(String event, Map<String, Object?> payload) {
    if (controlId.isEmpty) return;
    sendEvent(controlId, event, payload);
  }

  if (!enabled) return child;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: tapEnabled ? () => emit('tap', const {}) : null,
    onDoubleTap: doubleTapEnabled ? () => emit('double_tap', const {}) : null,
    onLongPress: longPressEnabled ? () => emit('long_press', const {}) : null,
    onPanStart: panEnabled ? (d) => emit('pan_start', {'dx': d.localPosition.dx, 'dy': d.localPosition.dy}) : null,
    onPanUpdate: panEnabled
        ? (d) => emit('pan_update', {
              'dx': d.delta.dx,
              'dy': d.delta.dy,
              'x': d.localPosition.dx,
              'y': d.localPosition.dy,
            })
        : null,
    onPanEnd: panEnabled ? (d) => emit('pan_end', {'vx': d.velocity.pixelsPerSecond.dx, 'vy': d.velocity.pixelsPerSecond.dy}) : null,
    onScaleStart: scaleEnabled ? (d) => emit('scale_start', {'x': d.localFocalPoint.dx, 'y': d.localFocalPoint.dy}) : null,
    onScaleUpdate: scaleEnabled
        ? (d) => emit('scale_update', {
              'scale': d.scale,
              'rotation': d.rotation,
              'x': d.localFocalPoint.dx,
              'y': d.localFocalPoint.dy,
            })
        : null,
    onScaleEnd: scaleEnabled ? (d) => emit('scale_end', {'vx': d.velocity.pixelsPerSecond.dx, 'vy': d.velocity.pixelsPerSecond.dy}) : null,
    child: child,
  );
}
