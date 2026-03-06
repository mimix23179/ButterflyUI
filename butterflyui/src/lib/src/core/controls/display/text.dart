import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';

Widget buildTextControl(
  Map<String, Object?> props, {
  required Color defaultText,
}) {
  final textValue = (props['text'] ?? props['value'] ?? '').toString();
  final size = coerceDouble(props['size'] ?? props['font_size']);
  final weight = _parseFontWeight(props['weight'] ?? props['font_weight']);
  final textBackground = resolveColorValue(
    props['background'] ??
        props['bgcolor'] ??
        props['surface'] ??
        props['surface_color'],
  );
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final color =
      resolveColorValue(
        props['color'] ?? props['text_color'] ?? props['foreground'],
        fallback: defaultText,
        background: textBackground,
        autoContrast: autoContrast,
        minContrast: minContrast,
      ) ??
      defaultText;
  final align = _parseTextAlign(props['align']);
  final maxLines = coerceOptionalInt(props['max_lines']);
  final overflow =
      _parseTextOverflow(props['overflow']) ??
      (maxLines != null ? TextOverflow.ellipsis : null);
  final style = TextStyle(
    color: color,
    fontSize: size,
    fontWeight: weight,
    fontFamily: props['font_family']?.toString(),
    fontStyle: props['italic'] == true ? FontStyle.italic : null,
    letterSpacing: coerceDouble(props['letter_spacing']),
    wordSpacing: coerceDouble(props['word_spacing']),
    height: coerceDouble(props['line_height']),
  );
  if (props['selectable'] == true) {
    return SelectableText(
      textValue,
      style: style,
      textAlign: align,
      maxLines: maxLines,
    );
  }
  return Text(
    textValue,
    style: style,
    textAlign: align,
    maxLines: maxLines,
    overflow: overflow,
  );
}

TextAlign? _parseTextAlign(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'left':
    case 'start':
      return TextAlign.start;
    case 'right':
    case 'end':
      return TextAlign.end;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
  }
  return null;
}

TextOverflow? _parseTextOverflow(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'clip':
      return TextOverflow.clip;
    case 'fade':
      return TextOverflow.fade;
    case 'visible':
      return TextOverflow.visible;
    case 'ellipsis':
      return TextOverflow.ellipsis;
  }
  return null;
}

FontWeight? _parseFontWeight(Object? value) {
  if (value == null) return null;
  if (value is int) return _fontWeightFromInt(value);
  final s = value.toString().toLowerCase();
  if (s == 'bold') return FontWeight.bold;
  if (s == 'normal') return FontWeight.normal;
  if (s.startsWith('w')) {
    final parsed = int.tryParse(s.substring(1));
    if (parsed != null) return _fontWeightFromInt(parsed);
  }
  final parsed = int.tryParse(s);
  if (parsed != null) return _fontWeightFromInt(parsed);
  return null;
}

FontWeight? _fontWeightFromInt(int value) {
  switch (value) {
    case 100:
      return FontWeight.w100;
    case 200:
      return FontWeight.w200;
    case 300:
      return FontWeight.w300;
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.w700;
    case 800:
      return FontWeight.w800;
    case 900:
      return FontWeight.w900;
  }
  return null;
}
