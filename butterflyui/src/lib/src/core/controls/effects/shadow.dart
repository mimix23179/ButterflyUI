import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildShadowControl(Map<String, Object?> props, Widget child) {
  final radius = coerceDouble(props['radius']) ?? 0.0;
  final configured = coerceBoxShadow(props['shadows']);
  final shadowColor = coerceColor(props['color']) ?? const Color(0x33000000);
  final blur = coerceDouble(props['blur']) ?? 12.0;
  final spread = coerceDouble(props['spread']) ?? 0.0;
  final offsetX = coerceDouble(props['offset_x']) ?? 0.0;
  final offsetY = coerceDouble(props['offset_y']) ?? 4.0;
  final shadows = configured ??
      <BoxShadow>[
        BoxShadow(
          color: shadowColor,
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(offsetX, offsetY),
        ),
      ];

  return DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: radius <= 0 ? null : BorderRadius.circular(radius),
      boxShadow: shadows,
    ),
    child: child,
  );
}
