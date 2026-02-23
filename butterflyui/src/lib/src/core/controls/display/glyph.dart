import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildGlyphControl(Map<String, Object?> props) {
  final glyph = (props['glyph'] ?? props['icon'] ?? '').toString();
  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final tooltip = props['tooltip']?.toString();

  Widget child;
  if (glyph.length == 1) {
    child = Text(glyph, style: TextStyle(fontSize: size ?? 18, color: color));
  } else {
    child = Icon(_parseIconData(glyph), size: size, color: color);
  }

  if (tooltip == null || tooltip.isEmpty) return child;
  return Tooltip(message: tooltip, child: child);
}

IconData _parseIconData(String name) {
  switch (name.toLowerCase()) {
    case 'add':
      return Icons.add;
    case 'close':
      return Icons.close;
    case 'check':
      return Icons.check;
    case 'edit':
      return Icons.edit;
    case 'delete':
      return Icons.delete;
    case 'search':
      return Icons.search;
    case 'menu':
      return Icons.menu;
    case 'more':
    case 'more_horiz':
      return Icons.more_horiz;
    case 'drag':
    case 'drag_indicator':
      return Icons.drag_indicator;
    default:
      return Icons.circle;
  }
}
