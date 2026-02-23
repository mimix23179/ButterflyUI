import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGlyphButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final glyph = (props['glyph'] ?? props['icon'] ?? '').toString();
  final tooltip = props['tooltip']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  final button = IconButton(
    icon: Icon(_parseIconData(glyph), size: coerceDouble(props['size']), color: coerceColor(props['color'])),
    onPressed: !enabled
        ? null
        : () {
            if (controlId.isEmpty) return;
            final payload = <String, Object?>{'glyph': glyph};
            sendEvent(controlId, 'click', payload);
            sendEvent(controlId, 'press', payload);
          },
  );

  if (tooltip == null || tooltip.isEmpty) return button;
  return Tooltip(message: tooltip, child: button);
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
