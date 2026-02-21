import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildProgressIndicatorControl(Map<String, Object?> props) {
  final rawValue = coerceDouble(props['value']);
  final indeterminate = props['indeterminate'] == true || rawValue == null;
  final value = indeterminate
      ? null
      : (rawValue > 1 ? rawValue / 100.0 : rawValue).clamp(0.0, 1.0);

  final variant =
      (props['variant']?.toString().toLowerCase() ??
              (props['circular'] == true ? 'circular' : 'linear'))
          .trim();
  final color = coerceColor(props['color']);
  final backgroundColor = coerceColor(props['background_color']);
  final strokeWidth = coerceDouble(props['stroke_width']) ?? 4;
  final label = props['label']?.toString();

  Widget indicator;
  if (variant == 'circular') {
    indicator = SizedBox(
      width: coerceDouble(props['size']) ?? 40,
      height: coerceDouble(props['size']) ?? 40,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
      ),
    );
  } else {
    indicator = LinearProgressIndicator(
      value: value,
      minHeight: strokeWidth,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  if (label == null || label.isEmpty) {
    return indicator;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      indicator,
      const SizedBox(height: 6),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    ],
  );
}
