import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPanZoomControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  Widget child = const SizedBox.shrink();
  if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    child = buildChild(coerceObjectMap(rawChildren.first as Map));
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
  }

  final enabled = props['enabled'] == null || props['enabled'] == true;
  final panEnabled = props['pan_enabled'] == null || props['pan_enabled'] == true;
  final zoomEnabled = props['zoom_enabled'] == null || props['zoom_enabled'] == true;

  final minScale = (coerceDouble(props['min_scale']) ?? 0.2).clamp(0.01, 100.0);
  final maxScale = (coerceDouble(props['max_scale']) ?? 4.0).clamp(minScale, 200.0);
  final events = _coercePanZoomEvents(props['events']);
  final throttleMs = (coerceOptionalInt(props['throttle_ms']) ?? 32).clamp(0, 1000);
  int lastUpdateEmitMs = 0;

  final boundaryMargin = coercePadding(props['boundary_margin']) ?? const EdgeInsets.all(80);
  final clip = props['clip'] == true ? Clip.hardEdge : Clip.none;

  return InteractiveViewer(
    minScale: minScale,
    maxScale: maxScale,
    panEnabled: enabled && panEnabled,
    scaleEnabled: enabled && zoomEnabled,
    boundaryMargin: boundaryMargin,
    clipBehavior: clip,
    onInteractionStart: controlId.isEmpty
        ? null
        : (details) {
            if (!events.contains('start')) return;
            sendEvent(controlId, 'start', {
              'focal_x': details.focalPoint.dx,
              'focal_y': details.focalPoint.dy,
            });
          },
    onInteractionUpdate: controlId.isEmpty
        ? null
        : (details) {
            if (!events.contains('update')) return;
            if (throttleMs > 0) {
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now - lastUpdateEmitMs < throttleMs) {
                return;
              }
              lastUpdateEmitMs = now;
            }
            sendEvent(controlId, 'update', {
              'focal_x': details.focalPoint.dx,
              'focal_y': details.focalPoint.dy,
              'scale': details.scale,
            });
          },
    onInteractionEnd: controlId.isEmpty
        ? null
        : (details) {
            if (!events.contains('end')) return;
            sendEvent(controlId, 'end', {
              'velocity_x': details.velocity.pixelsPerSecond.dx,
              'velocity_y': details.velocity.pixelsPerSecond.dy,
            });
          },
    child: child,
  );
}

Set<String> _coercePanZoomEvents(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final entry in value) {
      final normalized = entry?.toString().trim().toLowerCase();
      if (normalized == null || normalized.isEmpty) continue;
      if (normalized == 'start' || normalized == 'update' || normalized == 'end') {
        out.add(normalized);
      }
    }
  }
  if (out.isEmpty) {
    return <String>{'start', 'end'};
  }
  return out;
}
