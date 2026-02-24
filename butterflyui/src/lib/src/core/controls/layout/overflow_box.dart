import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildOverflowBoxControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final child = _resolveChild(props, rawChildren, buildChild);
  final alignment = _parseAlignment(props['alignment']) ?? Alignment.center;
  final minWidth = coerceDouble(props['min_width']);
  final minHeight = coerceDouble(props['min_height']);
  final maxWidth = coerceDouble(props['max_width']);
  final maxHeight = coerceDouble(props['max_height']);

  return OverflowBox(
    alignment: alignment,
    minWidth: minWidth,
    minHeight: minHeight,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    child: child,
  );
}

Widget _resolveChild(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  for (final raw in rawChildren) {
    if (raw is Map) {
      return buildChild(coerceObjectMap(raw));
    }
  }
  final propChild = props['child'];
  if (propChild is Map) {
    return buildChild(coerceObjectMap(propChild));
  }
  return const SizedBox.shrink();
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']) ?? 0.0;
    final y = coerceDouble(map['y']) ?? 0.0;
    return Alignment(x, y);
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'center':
      return Alignment.center;
    case 'top':
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom':
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'left':
    case 'start':
    case 'center_left':
      return Alignment.centerLeft;
    case 'right':
    case 'end':
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
  }
  return null;
}
