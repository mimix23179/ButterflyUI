import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDragPayloadControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final data = <String, Object?>{
    'data': props['data'],
    if (props['drag_type'] != null) 'drag_type': props['drag_type'],
    if (props['mime'] != null) 'mime': props['mime'],
  };

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  if (!enabled) return child;

  return Draggable<Map<String, Object?>>(
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
