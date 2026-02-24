import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildAspectRatioControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final ratio =
      coerceDouble(props['ratio'] ?? props['aspect_ratio']) ?? 1.0;
  final safeRatio = ratio <= 0 ? 1.0 : ratio;
  final child = _resolveChild(props, rawChildren, buildChild);
  return AspectRatio(aspectRatio: safeRatio, child: child);
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
