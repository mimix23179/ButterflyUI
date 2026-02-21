import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/candy/effects.dart';
import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildVignetteControl(
  Map<String, Object?> props,
  Widget child, {
  required Color defaultColor,
}) {
  return ConduitVignette(
    child: child,
    intensity: (coerceDouble(props['intensity'] ?? props['opacity']) ?? 0.45)
        .clamp(0.0, 1.0),
    color: coerceColor(props['color']) ?? defaultColor,
  );
}
