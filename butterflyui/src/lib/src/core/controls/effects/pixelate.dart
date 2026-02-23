import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildPixelateControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
) {
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  if (!enabled) return child;
  final amount = (coerceDouble(props['amount']) ?? 0.35).clamp(0.0, 1.0);
  final downscale = (1.0 - (amount * 0.9)).clamp(0.1, 1.0);

  return ClipRect(
    child: Transform.scale(
      scale: 1 / downscale,
      alignment: Alignment.center,
      filterQuality: FilterQuality.none,
      child: Transform.scale(
        scale: downscale,
        alignment: Alignment.center,
        filterQuality: FilterQuality.none,
        child: child,
      ),
    ),
  );
}
