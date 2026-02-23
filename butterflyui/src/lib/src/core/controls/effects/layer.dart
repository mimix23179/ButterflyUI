import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildLayerControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  if (props['visible'] == false) return const SizedBox.shrink();

  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  final opacity = coerceDouble(props['opacity']);
  if (opacity != null) {
    child = Opacity(opacity: opacity.clamp(0.0, 1.0), child: child);
  }

  final clip = props['clip'] == true;
  final radius = coerceDouble(
    props['clip_radius'] ?? props['border_radius'] ?? props['radius'],
  );
  if (clip) {
    final shape = (props['clip_shape'] ?? props['shape'] ?? '').toString().toLowerCase();
    if (shape == 'circle') {
      child = ClipOval(child: child);
    } else {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: child,
      );
    }
  }

  if (props['absorb_pointer'] == true) {
    child = AbsorbPointer(child: child);
  }
  if (props['ignore_pointer'] == true) {
    child = IgnorePointer(child: child);
  }

  return child;
}
