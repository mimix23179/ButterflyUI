import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildTypingIndicatorControl(Map<String, Object?> props) {
  final count = (coerceOptionalInt(props['dot_count']) ?? 3).clamp(1, 6);
  final color = parseColor(props['color']) ?? Colors.grey;
  final size = coerceDouble(props['size']) ?? 8;
  final spacing = coerceDouble(props['spacing']) ?? 4;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(count, (index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      );
    }),
  );
}
