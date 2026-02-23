import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOverlayControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final open = props['open'] == true;
  if (!open) return const SizedBox.shrink();

  Widget child = const SizedBox.shrink();
  if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    child = buildChild(coerceObjectMap(rawChildren.first as Map));
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
  }

  final dismissible = props['dismissible'] == null || props['dismissible'] == true;
  final scrim = coerceColor(props['scrim_color']) ?? Colors.black.withOpacity(0.35);
  final alignment = _coerceAlignment(props['alignment']);

  return Stack(
    fit: StackFit.expand,
    children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: dismissible && controlId.isNotEmpty
            ? () => sendEvent(controlId, 'dismiss', {})
            : null,
        child: ColoredBox(color: scrim),
      ),
      Align(alignment: alignment, child: child),
    ],
  );
}

Alignment _coerceAlignment(Object? raw) {
  final key = raw?.toString().toLowerCase().trim();
  switch (key) {
    case 'top':
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom':
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'left':
    case 'center_left':
      return Alignment.centerLeft;
    case 'right':
    case 'center_right':
      return Alignment.centerRight;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_right':
      return Alignment.bottomRight;
    default:
      return Alignment.center;
  }
}
