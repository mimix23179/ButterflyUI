import 'package:flutter/material.dart';

import '../control_utils.dart';
import 'theme_extension.dart';

String? resolveStylingTypeRoleName(
  Object? primary, {
  Object? secondary,
  String? fallback,
}) {
  return normalizeButterflyTypeRoleName(primary) ??
      normalizeButterflyTypeRoleName(secondary) ??
      normalizeButterflyTypeRoleName(fallback);
}

Map<String, Object?> resolveStylingTypeRole(
  ButterflyUIThemeTokens? tokens,
  Object? primary, {
  Object? secondary,
  String? fallback,
}) {
  if (tokens == null) return const <String, Object?>{};
  final roleName = resolveStylingTypeRoleName(
    primary,
    secondary: secondary,
    fallback: fallback,
  );
  return tokens.typeRole(roleName);
}

Color? stylingTypeRoleColor(Map<String, Object?> role) {
  return coerceColor(
    role['color'] ?? role['text_color'] ?? role['foreground'],
  );
}

double? stylingTypeRoleDouble(Map<String, Object?> role, String key) {
  return coerceDouble(role[key]);
}

String? stylingTypeRoleString(Map<String, Object?> role, String key) {
  return role[key]?.toString();
}

FontWeight? parseStylingFontWeight(Object? value) {
  if (value == null) return null;
  final normalized = value.toString().trim().toLowerCase();
  final numeric = int.tryParse(normalized);
  if (numeric != null) {
    return switch (numeric) {
      100 => FontWeight.w100,
      200 => FontWeight.w200,
      300 => FontWeight.w300,
      400 => FontWeight.w400,
      500 => FontWeight.w500,
      600 => FontWeight.w600,
      700 => FontWeight.w700,
      800 => FontWeight.w800,
      900 => FontWeight.w900,
      _ => null,
    };
  }
  return switch (normalized) {
    'thin' || 'w100' => FontWeight.w100,
    'extra_light' || 'extralight' || 'w200' => FontWeight.w200,
    'light' || 'w300' => FontWeight.w300,
    'normal' || 'regular' || 'w400' => FontWeight.w400,
    'medium' || 'w500' => FontWeight.w500,
    'semi_bold' || 'semibold' || 'w600' => FontWeight.w600,
    'bold' || 'w700' => FontWeight.w700,
    'extra_bold' || 'extrabold' || 'w800' => FontWeight.w800,
    'black' || 'w900' => FontWeight.w900,
    _ => null,
  };
}

FontStyle? parseStylingFontStyle(Object? value) {
  if (value == null) return null;
  if (value is bool) {
    return value ? FontStyle.italic : FontStyle.normal;
  }
  final normalized = value.toString().trim().toLowerCase();
  return switch (normalized) {
    'italic' || 'true' => FontStyle.italic,
    'normal' || 'false' => FontStyle.normal,
    _ => null,
  };
}
