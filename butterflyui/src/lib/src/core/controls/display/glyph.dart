import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';

Widget buildGlyphControl(Map<String, Object?> props) {
  final glyph = (props['glyph'] ?? props['icon'] ?? '').toString();
  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final tooltip = props['tooltip']?.toString();

  Widget child;
  child =
      buildIconValue(glyph, size: size ?? 18, color: color) ??
      Text(glyph, style: TextStyle(fontSize: size ?? 18, color: color));

  if (tooltip == null || tooltip.isEmpty) return child;
  return Tooltip(message: tooltip, child: child);
}

