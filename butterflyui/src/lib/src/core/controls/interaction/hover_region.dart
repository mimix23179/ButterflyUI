import 'package:flutter/gestures.dart';
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

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  if (!enabled) return child;

  void emit(String event, Map<String, Object?> payload) {
    if (controlId.isEmpty) return;
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
