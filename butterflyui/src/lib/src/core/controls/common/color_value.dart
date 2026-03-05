import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Color? resolveColorValue(
  Object? value, {
  Color? fallback,
  Color? background,
  bool autoContrast = false,
  double minContrast = 4.5,
}) {
  final parsed = _parseColorPayload(value) ?? fallback;
  if (parsed == null) return null;

  final opacity = _extractOpacity(value);
  var out = opacity == null
      ? parsed
      : parsed.withValues(
          alpha: (_colorOpacity(parsed) * opacity).clamp(0.0, 1.0),
        );

  final contrastWith = _resolveContrastBackground(value, background);
  final shouldAutoContrast = _extractAutoContrast(value) ?? autoContrast;
  final effectiveMinContrast = _extractMinContrast(value) ?? minContrast;

  if (contrastWith != null && shouldAutoContrast) {
    out = ensureMinContrast(
      out,
      contrastWith,
      minContrast: effectiveMinContrast,
    );
  }
  return out;
}

Color ensureMinContrast(
  Color foreground,
  Color background, {
  double minContrast = 4.5,
  Color light = Colors.white,
  Color dark = const Color(0xFF0F172A),
}) {
  if (contrastRatio(foreground, background) >= minContrast) {
    return foreground;
  }

  final lightRatio = contrastRatio(light, background);
  final darkRatio = contrastRatio(dark, background);
  final candidate = lightRatio >= darkRatio ? light : dark;
  if (contrastRatio(candidate, background) >= minContrast) {
    return candidate;
  }

  // If neither light nor dark hits the target (rare), choose the better one.
  return candidate;
}

Color bestForegroundFor(
  Color background, {
  Color light = Colors.white,
  Color dark = const Color(0xFF0F172A),
  double minContrast = 4.5,
}) {
  final lightRatio = contrastRatio(light, background);
  final darkRatio = contrastRatio(dark, background);
  final best = lightRatio >= darkRatio ? light : dark;
  return ensureMinContrast(
    best,
    background,
    minContrast: minContrast,
    light: light,
    dark: dark,
  );
}

bool isDarkColor(Color color) {
  return relativeLuminance(color) < 0.5;
}

double relativeLuminance(Color color) {
  return color.computeLuminance();
}

double contrastRatio(Color first, Color second) {
  final l1 = first.computeLuminance();
  final l2 = second.computeLuminance();
  final hi = math.max(l1, l2);
  final lo = math.min(l1, l2);
  return (hi + 0.05) / (lo + 0.05);
}

int colorToArgb32(Color color) {
  return (_channel8(color.a) << 24) |
      (_channel8(color.r) << 16) |
      (_channel8(color.g) << 8) |
      _channel8(color.b);
}

String colorToHex(Color color, {bool includeAlpha = true}) {
  final argb = colorToArgb32(color);
  final a = ((argb >> 24) & 0xFF).toRadixString(16).padLeft(2, '0');
  final r = ((argb >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
  final g = ((argb >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
  final b = (argb & 0xFF).toRadixString(16).padLeft(2, '0');
  if (includeAlpha) {
    return '#${a.toUpperCase()}${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
  }
  return '#${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
}

int _channel8(double unit) {
  return (unit * 255.0).round().clamp(0, 255);
}

double _colorOpacity(Color color) {
  return color.a.clamp(0.0, 1.0);
}

Color? _parseColorPayload(Object? value) {
  if (value == null) return null;
  if (value is Map) {
    final map = coerceObjectMap(value);
    final typeToken = map['type']?.toString().trim().toLowerCase();
    if (typeToken != null && typeToken.isNotEmpty && map['props'] is Map) {
      final nestedProps = coerceObjectMap(map['props'] as Map);
      if (typeToken == 'color') {
        return _parseColorPayload(
          nestedProps['value'] ?? nestedProps['color'] ?? nestedProps,
        );
      }
      if (typeToken == 'icon') {
        return _parseColorPayload(
          nestedProps['color'] ??
              nestedProps['foreground'] ??
              nestedProps['icon_color'],
        );
      }
    }
    final direct =
        map['value'] ??
        map['color'] ??
        map['hex'] ??
        map['argb'] ??
        map['rgba'] ??
        map['token'] ??
        map['role'] ??
        map['name'];
    if (direct != null) {
      final parsedDirect = coerceColor(direct);
      if (parsedDirect != null) return parsedDirect;
    }
    return coerceColor(map);
  }
  return coerceColor(value);
}

Color? _resolveContrastBackground(Object? value, Color? background) {
  if (value is! Map) return background;
  final map = coerceObjectMap(value);
  final raw =
      map['contrast_with'] ??
      map['contrastWith'] ??
      map['background'] ??
      map['bgcolor'] ??
      map['on'];
  return _parseColorPayload(raw) ?? background;
}

double? _extractOpacity(Object? value) {
  if (value is! Map) return null;
  final map = coerceObjectMap(value);
  final opacity = coerceDouble(map['opacity'] ?? map['alpha']);
  if (opacity == null) return null;
  if (opacity > 1.0) {
    return (opacity / 255.0).clamp(0.0, 1.0);
  }
  return opacity.clamp(0.0, 1.0);
}

bool? _extractAutoContrast(Object? value) {
  if (value is! Map) return null;
  final map = coerceObjectMap(value);
  return coerceBool(
    map['auto_contrast'] ?? map['autoContrast'] ?? map['ensure_contrast'],
  );
}

double? _extractMinContrast(Object? value) {
  if (value is! Map) return null;
  final map = coerceObjectMap(value);
  return coerceDouble(map['min_contrast'] ?? map['minContrast']);
}
