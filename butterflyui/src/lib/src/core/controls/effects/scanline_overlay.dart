import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/candy/effects.dart';
import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildScanlineOverlayControl(
  Map<String, Object?> props,
  Widget child, {
  required Color defaultText,
}) {
  return ConduitScanlineOverlay(
    child: child,
    spacing: (coerceDouble(props['spacing'] ?? props['line_spacing']) ?? 6)
        .clamp(1.0, 256.0),
    thickness:
        (coerceDouble(props['thickness'] ?? props['line_thickness']) ?? 1)
            .clamp(0.5, 32.0),
    opacity: (coerceDouble(props['opacity']) ?? 0.18).clamp(0.0, 1.0),
    color: coerceColor(props['color']) ?? defaultText,
  );
}
