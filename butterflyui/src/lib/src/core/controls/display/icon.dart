import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconControl(
  IconData iconData,
  Map<String, Object?> props,
) {
  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final tooltip = props['tooltip']?.toString();
  final icon = Icon(iconData, size: size, color: color);
  if (tooltip == null || tooltip.isEmpty) return icon;
  return Tooltip(message: tooltip, child: icon);
}

Widget buildEmojiIconControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final emoji = (props['emoji'] ?? props['value'] ?? '').toString();
  final fallback = (props['fallback'] ?? '😀').toString();
  final resolvedEmoji = emoji.isEmpty ? fallback : emoji;
  final label = props['label']?.toString();
  final size = coerceDouble(props['size']) ?? 20;
  final color = coerceColor(props['color']);
  final background = coerceColor(props['background'] ?? props['bgcolor']);
  final radius = coerceDouble(props['radius']) ?? 8;
  final padding = coercePadding(props['padding']) ?? const EdgeInsets.all(4);
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final text = Text(
    resolvedEmoji,
    style: TextStyle(fontSize: size, color: color),
  );

  Widget child = text;
  if (background != null) {
    child = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(padding: padding, child: text),
    );
  }
  if (label != null && label.isNotEmpty) {
    child = Tooltip(message: label, child: child);
  }

  if (controlId.isEmpty || !enabled) return child;
  return InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () {
      sendEvent(controlId, 'select', {
        'emoji': resolvedEmoji,
        'label': label ?? '',
      });
    },
    child: child,
  );
}
