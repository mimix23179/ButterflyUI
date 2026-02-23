import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildMotionControl(
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

  final durationMs = (coerceOptionalInt(props['duration_ms']) ?? 240).clamp(1, 600000);
  final play = props['play'] != false;
  final opacity = (coerceDouble(props['opacity']) ?? 1.0).clamp(0.0, 1.0);
  final scale = (coerceDouble(props['scale']) ?? 1.0).clamp(0.01, 8.0);

  return AnimatedOpacity(
    duration: Duration(milliseconds: durationMs),
    opacity: play ? opacity : 1.0,
    child: AnimatedScale(
      duration: Duration(milliseconds: durationMs),
      scale: play ? scale : 1.0,
      child: child,
    ),
  );
}
