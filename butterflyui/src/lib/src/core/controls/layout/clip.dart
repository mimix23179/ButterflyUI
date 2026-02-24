import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildClipControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final child = _resolveChild(props, rawChildren, buildChild);
  final clipBehavior = _parseClip(props['clip_behavior']) ?? Clip.antiAlias;
  final shape = (props['shape'] ?? 'rrect').toString().toLowerCase();
  final radius = coerceDouble(props['radius'] ?? props['border_radius']) ?? 0.0;

  switch (shape) {
    case 'oval':
    case 'circle':
      return ClipOval(clipBehavior: clipBehavior, child: child);
    case 'rect':
    case 'rectangle':
      return ClipRect(clipBehavior: clipBehavior, child: child);
    default:
      return ClipRRect(
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.circular(radius),
        child: child,
      );
  }
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

Clip? _parseClip(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'none':
      return Clip.none;
    case 'hardedge':
    case 'hard_edge':
      return Clip.hardEdge;
    case 'antialias':
    case 'anti_alias':
      return Clip.antiAlias;
    case 'antialiaswithsavelayer':
    case 'anti_alias_with_save_layer':
      return Clip.antiAliasWithSaveLayer;
  }
  return null;
}
