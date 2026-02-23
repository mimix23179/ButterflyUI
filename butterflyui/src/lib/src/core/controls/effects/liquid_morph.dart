import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildLiquidMorphControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }

  final minRadius = coerceDouble(props['min_radius']) ?? 8;
  final maxRadius = coerceDouble(props['max_radius']) ?? 24;
  final animate = props['animate'] != false;
  final durationMs = (coerceOptionalInt(props['duration_ms']) ?? 1200).clamp(1, 600000);
  final targetRadius = animate ? maxRadius : minRadius;

  return AnimatedContainer(
    duration: Duration(milliseconds: durationMs),
    curve: Curves.easeInOut,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(math.max(0, targetRadius)),
    ),
    child: child,
  );
}
