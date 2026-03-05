import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconControl(Object? iconValue, Map<String, Object?> props) {
  final size = coerceDouble(props['size']);
  final background = resolveColorValue(props['background'] ?? props['bgcolor']);
  final borderColor = resolveColorValue(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 0.0;
  final radius = coerceDouble(props['radius']) ?? 8.0;
  final padding = coercePadding(props['padding']) ?? EdgeInsets.zero;
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final tooltip =
      (props['tooltip'] ?? props['label'] ?? props['semantic_label'])
          ?.toString();

  final widget =
      buildIconValue(
        iconValue,
        colorValue: props['color'] ?? props['foreground'],
        background: background,
        size: size,
        autoContrast: autoContrast,
        minContrast: minContrast,
        fallbackIcon: Icons.help_outline,
      ) ??
      Icon(
        Icons.help_outline,
        size: size,
        color: bestForegroundFor(
          background ?? const Color(0xFF111827),
          minContrast: minContrast,
        ),
      );

  Widget out = widget;
  if (padding != EdgeInsets.zero ||
      background != null ||
      borderColor != null ||
      borderWidth > 0.0) {
    out = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null || borderWidth <= 0
            ? null
            : Border.all(color: borderColor, width: borderWidth),
      ),
      child: Padding(padding: padding, child: out),
    );
  }

  if (tooltip != null && tooltip.isNotEmpty) {
    out = Tooltip(message: tooltip, child: out);
  }
  return out;
}

Widget buildEmojiIconControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final emoji = (props['emoji'] ?? props['value'] ?? '').toString();
  final fallback = (props['fallback'] ?? '\u{1F600}').toString();
  final resolvedEmoji = emoji.isEmpty ? fallback : emoji;
  final label = props['label']?.toString();
  final size = coerceDouble(props['size']) ?? 20;
  final background = resolveColorValue(props['background'] ?? props['bgcolor']);
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final color =
      resolveColorValue(
        props['color'] ?? props['foreground'],
        background: background,
        autoContrast: coerceBool(props['auto_contrast']) ?? true,
        minContrast: minContrast,
      ) ??
      bestForegroundFor(
        background ?? const Color(0xFF111827),
        minContrast: minContrast,
      );
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
