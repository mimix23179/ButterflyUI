import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildHoverRegionControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null || props['enabled'] == true;
  final opaque = props['opaque'] == true;
  final cursor = _cursorFor(props['cursor']?.toString());
  final events = _coerceEvents(props['events']);
  final throttleMs = (coerceOptionalInt(props['throttle_ms']) ?? 32).clamp(0, 1000);

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  if (!enabled) return child;

  int lastHoverEmitMs = 0;

  void emit(String event, Map<String, Object?> payload) {
    if (controlId.isEmpty) return;
    if (!events.contains(event)) return;
    if (event == 'hover' && throttleMs > 0) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastHoverEmitMs < throttleMs) {
        return;
      }
      lastHoverEmitMs = now;
    }
    sendEvent(controlId, event, payload);
  }

  return MouseRegion(
    opaque: opaque,
    cursor: cursor,
    onEnter: (event) => emit('enter', {
      'x': event.localPosition.dx,
      'y': event.localPosition.dy,
    }),
    onExit: (event) => emit('exit', {
      'x': event.localPosition.dx,
      'y': event.localPosition.dy,
    }),
    onHover: (event) => emit('hover', {
      'x': event.localPosition.dx,
      'y': event.localPosition.dy,
    }),
    child: child,
  );
}

Set<String> _coerceEvents(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final entry in value) {
      final normalized = entry?.toString().trim().toLowerCase();
      if (normalized == null || normalized.isEmpty) continue;
      if (normalized == 'enter' || normalized == 'exit' || normalized == 'hover') {
        out.add(normalized);
      }
    }
  }
  if (out.isEmpty) {
    return <String>{'enter', 'exit'};
  }
  return out;
}

MouseCursor _cursorFor(String? name) {
  switch ((name ?? '').toLowerCase()) {
    case 'click':
    case 'pointer':
    case 'hand':
      return SystemMouseCursors.click;
    case 'text':
      return SystemMouseCursors.text;
    case 'move':
      return SystemMouseCursors.move;
    case 'forbidden':
    case 'not_allowed':
      return SystemMouseCursors.forbidden;
    case 'cross':
    case 'crosshair':
      return SystemMouseCursors.precise;
    default:
      return SystemMouseCursors.basic;
  }
}
