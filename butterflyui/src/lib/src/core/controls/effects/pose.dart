import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildPoseControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
) {
  final x = coerceDouble(props['x']) ?? 0;
  final y = coerceDouble(props['y']) ?? 0;
  final z = coerceDouble(props['z']) ?? 0;
  final scale = coerceDouble(props['scale']) ?? 1.0;
  final rotateDeg = coerceDouble(props['rotate']) ?? 0.0;
  final opacity = (coerceDouble(props['opacity']) ?? 1.0).clamp(0.0, 1.0);

  Widget posed = Transform(
    transform: Matrix4.identity()
      ..translate(x, y, z)
      ..scale(scale)
      ..rotateZ(rotateDeg * (math.pi / 180.0)),
    alignment: Alignment.center,
    child: child,
  );

  if (opacity < 1.0) {
    posed = Opacity(opacity: opacity, child: posed);
  }
  return posed;
}
