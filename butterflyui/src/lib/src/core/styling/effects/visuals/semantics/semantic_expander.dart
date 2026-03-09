import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

List<String> coerceEffectStringList(Object? value) {
  if (value == null) return const <String>[];
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? const <String>[] : <String>[trimmed];
  }
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
  return <String>[value.toString().trim()];
}

String normalizeEffectToken(Object? value) {
  if (value == null) return '';
  return value
      .toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
}

void applyEffectSemanticToken(Map<String, Object?> props, String token) {
  switch (normalizeEffectToken(token)) {
    case 'matrix_rain':
    case 'matrix':
    case 'cyber':
      props.putIfAbsent('scanline', () => true);
      break;
    case 'leaf_drift':
    case 'leaves':
    case 'particles':
      props.putIfAbsent('particles', () => true);
      break;
    case 'hover_tilt':
    case 'magnetic_pull':
    case 'magnetic':
    case 'parallax':
      props.putIfAbsent('parallax', () => true);
      break;
    case 'rainbow_border':
    case 'shimmer_glow':
      props.putIfAbsent('glow', () => true);
      break;
    case 'scanline':
      props.putIfAbsent('scanline', () => true);
      break;
    case 'vignette':
      props.putIfAbsent('vignette', () => true);
      break;
    case 'shimmer':
      props.putIfAbsent('shimmer', () => true);
      break;
    case 'glow':
      props.putIfAbsent('glow', () => true);
      break;
    default:
      break;
  }
}

Map<String, Object?> expandEffectSemanticProps(Map<String, Object?> rawProps) {
  final expanded = Map<String, Object?>.from(rawProps);

  final preset = expanded['preset'] ?? expanded['profile'];
  if (preset != null) {
    applyEffectSemanticToken(expanded, preset.toString());
  }

  for (final token in coerceEffectStringList(expanded['ambient'])) {
    applyEffectSemanticToken(expanded, token);
  }
  for (final token in coerceEffectStringList(expanded['reactive'])) {
    applyEffectSemanticToken(expanded, token);
  }
  for (final token in coerceEffectStringList(expanded['decor'])) {
    applyEffectSemanticToken(expanded, token);
  }

  final hasNativeScene =
      expanded['scene'] != null ||
      expanded['scene_layers'] != null ||
      expanded['background_layers'] != null ||
      expanded['overlay_layers'] != null ||
      expanded['lottie_asset'] != null ||
      expanded['lottie_url'] != null ||
      expanded['lottie_data'] != null ||
      expanded['lottie_json'] != null ||
      expanded['rive_asset'] != null ||
      expanded['rive_url'] != null;
  if (hasNativeScene) {
    if (!rawProps.containsKey('animated_background')) {
      expanded.remove('animated_background');
    }
    if (!rawProps.containsKey('liquid_morph')) {
      expanded.remove('liquid_morph');
    }
  }

  if (expanded['apply_to'] != null && expanded['target'] == null) {
    expanded['target'] = expanded['apply_to'];
  }
  if (expanded['target'] != null && expanded['mode'] == null) {
    expanded['mode'] = 'enhance';
  }

  return expanded;
}

bool resolveStylingIsDark(
  Map<String, Object?> props,
  StylingTokens tokens, {
  bool? inheritedIsDark,
  Brightness? fallbackBrightness,
}) {
  final brightness = props['brightness']?.toString().trim().toLowerCase();
  if (brightness != null && brightness.isNotEmpty) {
    return brightness.startsWith('dark');
  }

  final tokenBrightness = tokens
      .themeString('brightness')
      ?.trim()
      .toLowerCase();
  if (tokenBrightness != null && tokenBrightness.isNotEmpty) {
    return tokenBrightness.startsWith('dark');
  }

  final paletteColor =
      coerceColor(props['bgcolor'] ?? props['background']) ??
      tokens.color('background') ??
      tokens.color('surface');
  if (paletteColor != null) {
    return ThemeData.estimateBrightnessForColor(paletteColor) ==
        Brightness.dark;
  }

  if (inheritedIsDark != null) {
    return inheritedIsDark;
  }
  return fallbackBrightness == Brightness.dark;
}
