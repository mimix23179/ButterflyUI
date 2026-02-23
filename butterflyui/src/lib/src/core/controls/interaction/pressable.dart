import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPressableControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final hoverEnabled = props['hover_enabled'] == null || props['hover_enabled'] == true;
  final focusEnabled = props['focus_enabled'] == null || props['focus_enabled'] == true;

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  if (!enabled) return child;

  void emit(String event, [Map<String, Object?> payload = const {}]) {
    if (controlId.isEmpty) return;
    sendEvent(controlId, event, payload);
  }

  return FocusableActionDetector(
    enabled: enabled,
    onFocusChange: focusEnabled ? (focused) => emit('focus', {'focused': focused}) : null,
    onShowHoverHighlight: hoverEnabled ? (hovered) => emit('hover', {'hovered': hovered}) : null,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => emit('press', const {}),
        onTapDown: (d) => emit('press_down', {'x': d.localPosition.dx, 'y': d.localPosition.dy}),
        onTapCancel: () => emit('press_cancel', const {}),
        onTapUp: (d) => emit('press_up', {'x': d.localPosition.dx, 'y': d.localPosition.dy}),
        child: child,
      ),
    ),
  );
}
