import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDragHandleControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final payload = props['payload'] is Map
      ? coerceObjectMap(props['payload'] as Map)
      : <String, Object?>{};
  final data = <String, Object?>{
    ...payload,
    if (props['index'] != null) 'index': props['index'],
    if (props['drag_type'] != null) 'drag_type': props['drag_type'],
  };

  Widget child = const Icon(Icons.drag_indicator);
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  if (!enabled) return child;

  return LongPressDraggable<Map<String, Object?>>(
    data: data,
    onDragStarted: () => _emit(sendEvent, controlId, 'drag_start', data),
    onDragEnd: (_) => _emit(sendEvent, controlId, 'drag_end', data),
    onDraggableCanceled: (_, __) => _emit(sendEvent, controlId, 'drag_cancel', data),
    feedback: Material(color: Colors.transparent, child: Opacity(opacity: 0.85, child: child)),
    childWhenDragging: Opacity(opacity: 0.45, child: child),
    child: child,
  );
}

void _emit(
  ButterflyUISendRuntimeEvent sendEvent,
  String controlId,
  String event,
  Map<String, Object?> payload,
) {
  if (controlId.isEmpty) return;
  sendEvent(controlId, event, payload);
}
