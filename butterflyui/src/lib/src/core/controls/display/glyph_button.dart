import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGlyphButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final glyph = (props['glyph'] ?? props['icon'] ?? '').toString();
  final tooltip = props['tooltip']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final iconWidget =
      buildIconValue(glyph, size: size, color: color) ??
      Icon(Icons.circle, size: size, color: color);
  final button = IconButton(
    icon: iconWidget,
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

