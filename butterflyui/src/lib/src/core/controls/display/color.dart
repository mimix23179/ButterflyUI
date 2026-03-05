import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildColorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final background = resolveColorValue(props['background'] ?? props['bgcolor']);
  final color =
      resolveColorValue(
        props['value'] ?? props['color'] ?? props,
        background: background,
        autoContrast: coerceBool(props['auto_contrast']) ?? false,
        minContrast: minContrast,
      ) ??
      const Color(0x00000000);

  final label = props['label']?.toString();
  final showLabel =
      coerceBool(props['show_label']) ?? (label != null && label.isNotEmpty);
  final showHex = coerceBool(props['show_hex']) ?? false;

  final size = coerceDouble(props['size']) ?? 24.0;
  final width = coerceDouble(props['width']) ?? size;
  final height = coerceDouble(props['height']) ?? size;
  final radius = coerceDouble(props['radius']) ?? 8.0;
  final shape = _normalizeShape(props['shape']?.toString());
  final borderColor = resolveColorValue(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final padding = coercePadding(props['padding']) ?? const EdgeInsets.all(6);
  final gap = coerceDouble(props['spacing']) ?? 8.0;
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  final swatch = Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : BorderRadius.circular(radius),
      border: Border.all(
        color:
            borderColor ??
            bestForegroundFor(color, minContrast: 3.0).withValues(alpha: 0.24),
        width: borderWidth,
      ),
    ),
  );

  final texts = <Widget>[];
  if (showLabel && label != null && label.isNotEmpty) {
    texts.add(
      Text(
        label,
        style: TextStyle(
          color:
              resolveColorValue(
                props['text_color'] ?? props['foreground'],
                background: background,
                autoContrast: true,
                minContrast: minContrast,
              ) ??
              bestForegroundFor(
                background ?? const Color(0xFF0B1220),
                minContrast: minContrast,
              ),
          fontSize: coerceDouble(props['font_size']) ?? 13.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  if (showHex) {
    texts.add(
      Text(
        colorToHex(color, includeAlpha: true),
        style: TextStyle(
          color:
              resolveColorValue(
                props['meta_color'],
                background: background,
                autoContrast: true,
                minContrast: 3.0,
              ) ??
              bestForegroundFor(
                background ?? const Color(0xFF0B1220),
                minContrast: 3.0,
              ).withValues(alpha: 0.72),
          fontSize: coerceDouble(props['meta_size']) ?? 11.0,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget child;
  if (texts.isEmpty) {
    child = swatch;
  } else {
    child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        SizedBox(width: gap),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: texts,
          ),
        ),
      ],
    );
  }

  child = Padding(padding: padding, child: child);
  if (background != null) {
    child = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  if (!enabled || controlId.isEmpty) return child;
  return InkWell(
    borderRadius: BorderRadius.circular(radius),
    onTap: () {
      sendEvent(controlId, 'select', {
        'argb': colorToArgb32(color),
        'hex': colorToHex(color, includeAlpha: true),
        'rgb': colorToHex(color, includeAlpha: false),
        'label': label ?? '',
      });
    },
    child: child,
  );
}

BoxShape _normalizeShape(String? raw) {
  final value = (raw ?? '').trim().toLowerCase();
  if (value == 'circle' || value == 'dot') {
    return BoxShape.circle;
  }
  return BoxShape.rectangle;
}
