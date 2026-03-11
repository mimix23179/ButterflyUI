import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/styling/type_roles.dart';

Widget buildTextControl(
  Map<String, Object?> props, {
  required Color defaultText,
  ButterflyUIThemeTokens? tokens,
}) {
  final slotStyles = props['__slot_styles'] is Map
      ? coerceObjectMap(props['__slot_styles'] as Map)
      : <String, Object?>{};
  final rootSlot = slotStyles['root'] is Map
      ? coerceObjectMap(slotStyles['root'] as Map)
      : <String, Object?>{};
  final labelSlot = slotStyles['label'] is Map
      ? coerceObjectMap(slotStyles['label'] as Map)
      : <String, Object?>{};
  final contentSlot = slotStyles['content'] is Map
      ? coerceObjectMap(slotStyles['content'] as Map)
      : <String, Object?>{};
  final backgroundSlot = slotStyles['background'] is Map
      ? coerceObjectMap(slotStyles['background'] as Map)
      : <String, Object?>{};
  final borderSlot = slotStyles['border'] is Map
      ? coerceObjectMap(slotStyles['border'] as Map)
      : <String, Object?>{};
  final textValue = (props['text'] ?? props['value'] ?? '').toString();
  final typeRole = resolveStylingTypeRole(
    tokens,
    props['type_role'] ?? props['text_role'],
    secondary:
        labelSlot['type_role'] ??
        labelSlot['text_role'] ??
        contentSlot['type_role'] ??
        contentSlot['text_role'],
    fallback: _defaultTextRole(props),
  );
  final size = coerceDouble(
    props['size'] ??
        props['font_size'] ??
        labelSlot['size'] ??
        labelSlot['font_size'] ??
        contentSlot['size'] ??
        contentSlot['font_size'] ??
        typeRole['font_size'] ??
        typeRole['size'],
  );
  final weight = parseStylingFontWeight(
    props['weight'] ??
        props['font_weight'] ??
        labelSlot['weight'] ??
        labelSlot['font_weight'] ??
        contentSlot['weight'] ??
        contentSlot['font_weight'] ??
        typeRole['weight'] ??
        typeRole['font_weight'],
  );
  final textBackground = resolveColorValue(
    props['background'] ??
        props['bgcolor'] ??
        props['surface'] ??
        props['surface_color'] ??
        backgroundSlot['background'] ??
        backgroundSlot['bgcolor'] ??
        rootSlot['background'] ??
        rootSlot['bgcolor'],
  );
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final color =
      resolveColorValue(
        props['color'] ??
            props['text_color'] ??
            props['foreground'] ??
            labelSlot['color'] ??
            labelSlot['text_color'] ??
            labelSlot['foreground'] ??
            contentSlot['color'] ??
            contentSlot['text_color'] ??
            contentSlot['foreground'] ??
            stylingTypeRoleColor(typeRole),
        fallback: defaultText,
        background: textBackground,
        autoContrast: autoContrast,
        minContrast: minContrast,
      ) ??
      defaultText;
  final align = _parseTextAlign(
    props['align'] ?? labelSlot['align'] ?? labelSlot['text_align'],
  );
  final maxLines = coerceOptionalInt(props['max_lines']);
  final overflow =
      _parseTextOverflow(props['overflow']) ??
      (maxLines != null ? TextOverflow.ellipsis : null);
  final textTransform =
      (props['text_transform'] ??
              labelSlot['text_transform'] ??
              contentSlot['text_transform'] ??
              typeRole['text_transform'])
          ?.toString()
          .toLowerCase()
          .trim();
  final textDecoration = _parseTextDecoration(
    props['text_decoration'] ??
        props['decoration'] ??
        labelSlot['text_decoration'] ??
        labelSlot['decoration'] ??
        contentSlot['text_decoration'] ??
        contentSlot['decoration'] ??
        typeRole['text_decoration'],
  );
  final decorationColor = resolveColorValue(
    props['decoration_color'] ??
        labelSlot['decoration_color'] ??
        contentSlot['decoration_color'] ??
        typeRole['decoration_color'],
  );
  final decorationStyle = _parseTextDecorationStyle(
    props['decoration_style'] ??
        labelSlot['decoration_style'] ??
        contentSlot['decoration_style'] ??
        typeRole['decoration_style'],
  );
  final fontStyle = parseStylingFontStyle(
    props['italic'] ??
        labelSlot['italic'] ??
        contentSlot['italic'] ??
        props['font_style'] ??
        labelSlot['font_style'] ??
        contentSlot['font_style'] ??
        typeRole['font_style'] ??
        typeRole['italic'],
  );
  final textShadow = _coerceTextShadows(
    props['text_shadow'] ??
        props['shadow'] ??
        labelSlot['text_shadow'] ??
        contentSlot['text_shadow'],
  );
  final resolvedText = _applyTextTransform(textValue, textTransform);
  final style = TextStyle(
    color: color,
    fontSize: size,
    fontWeight: weight,
    fontFamily:
        props['font_family']?.toString() ??
        labelSlot['font_family']?.toString() ??
        contentSlot['font_family']?.toString() ??
        typeRole['font_family']?.toString(),
    fontStyle: fontStyle,
    letterSpacing: coerceDouble(
      props['letter_spacing'] ??
          labelSlot['letter_spacing'] ??
          contentSlot['letter_spacing'] ??
          typeRole['letter_spacing'],
    ),
    wordSpacing: coerceDouble(
      props['word_spacing'] ??
          labelSlot['word_spacing'] ??
          contentSlot['word_spacing'],
    ),
    height: coerceDouble(
      props['line_height'] ??
          labelSlot['line_height'] ??
          contentSlot['line_height'] ??
          typeRole['line_height'],
    ),
    decoration: textDecoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    shadows: textShadow,
  );
  final backgroundColor = resolveColorValue(
    props['bgcolor'] ??
        props['background'] ??
        backgroundSlot['bgcolor'] ??
        backgroundSlot['background'] ??
        rootSlot['bgcolor'] ??
        rootSlot['background'],
  );
  final gradient = coerceGradient(
    props['gradient'] ??
        backgroundSlot['gradient'] ??
        rootSlot['gradient'],
  );
  final padding = coercePadding(
    props['padding'] ?? contentSlot['padding'] ?? rootSlot['padding'],
  );
  final radius = coerceDouble(
    props['radius'] ??
        borderSlot['radius'] ??
        borderSlot['border_radius'] ??
        rootSlot['radius'],
  );
  final borderColor = resolveColorValue(
    props['border_color'] ??
        borderSlot['border_color'] ??
        borderSlot['color'] ??
        rootSlot['border_color'],
  );
  final borderWidth = coerceDouble(
    props['border_width'] ?? borderSlot['border_width'],
  );
  final boxShadow = coerceBoxShadow(
    props['shadow'] ?? backgroundSlot['shadow'] ?? rootSlot['shadow'],
  );
  final hasDecoration =
      backgroundColor != null ||
      gradient != null ||
      padding != null ||
      boxShadow != null ||
      borderColor != null;
  if (props['selectable'] == true) {
    Widget child = SelectableText(
      resolvedText,
      style: style,
      textAlign: align,
      maxLines: maxLines,
    );
    if (hasDecoration) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor, width: borderWidth ?? 1.0),
          borderRadius: radius == null ? null : BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      );
    }
    return child;
  }
  Widget child = Text(
    resolvedText,
    style: style,
    textAlign: align,
    maxLines: maxLines,
    overflow: overflow,
  );
  if (hasDecoration) {
    child = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth ?? 1.0),
        borderRadius: radius == null ? null : BorderRadius.circular(radius),
        boxShadow: boxShadow,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
  return child;
}

String _defaultTextRole(Map<String, Object?> props) {
  final role =
          normalizeButterflyTypeRoleName(
            props['role'] ?? props['variant'] ?? props['kind'],
          ) ??
      '';
  switch (role) {
    case 'display_hero':
    case 'display':
    case 'headline':
    case 'heading':
    case 'title':
    case 'body_lg':
    case 'body':
    case 'caption':
    case 'helper':
    case 'button_label':
    case 'input':
    case 'nav':
    case 'overline':
      return role;
  }
  return 'body';
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

TextDecoration? _parseTextDecoration(Object? value) {
  final normalized = value?.toString().trim().toLowerCase();
  switch (normalized) {
    case 'underline':
      return TextDecoration.underline;
    case 'line_through':
    case 'strikethrough':
    case 'strike':
      return TextDecoration.lineThrough;
    case 'overline':
      return TextDecoration.overline;
    case 'none':
      return TextDecoration.none;
  }
  return null;
}

TextDecorationStyle? _parseTextDecorationStyle(Object? value) {
  final normalized = value?.toString().trim().toLowerCase();
  switch (normalized) {
    case 'dashed':
      return TextDecorationStyle.dashed;
    case 'dotted':
      return TextDecorationStyle.dotted;
    case 'double':
      return TextDecorationStyle.double;
    case 'wavy':
      return TextDecorationStyle.wavy;
    case 'solid':
      return TextDecorationStyle.solid;
  }
  return null;
}

String _applyTextTransform(String value, String? transform) {
  switch (transform) {
    case 'uppercase':
      return value.toUpperCase();
    case 'lowercase':
      return value.toLowerCase();
    case 'capitalize':
      return value
          .split(RegExp(r'(\s+)'))
          .map((part) {
            if (part.trim().isEmpty) return part;
            return '${part[0].toUpperCase()}${part.substring(1)}';
          })
          .join();
    default:
      return value;
  }
}

List<Shadow>? _coerceTextShadows(Object? value) {
  if (value == null) return null;
  final asBoxShadow = coerceBoxShadow(value);
  if (asBoxShadow != null) {
    return asBoxShadow
        .map(
          (shadow) => Shadow(
            color: shadow.color,
            blurRadius: shadow.blurRadius,
            offset: shadow.offset,
          ),
        )
        .toList(growable: false);
  }
  return null;
}
