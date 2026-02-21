import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildDividerControl(Map<String, Object?> props, List children, Widget Function(Map<String, Object?> child) buildFromControl, {Color? fallbackColor}) {
  final vertical = props['vertical'] == true;
  final thickness = coerceDouble(props['thickness']);
  final indent = coerceDouble(props['indent']);
  final endIndent = coerceDouble(props['end_indent']);
  final color = coerceColor(props['color']) ?? fallbackColor;
  return vertical
      ? VerticalDivider(thickness: thickness, width: thickness, indent: indent, endIndent: endIndent, color: color)
      : Divider(thickness: thickness, indent: indent, endIndent: endIndent, color: color);
}