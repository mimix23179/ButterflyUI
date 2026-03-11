import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

enum EffectLayerKind {
  gradientWash,
  matrixRain,
  starfield,
  particleField,
  lineField,
  orbitField,
  noiseField,
  rain,
  nebula,
  liquidGlow,
  asset,
  shader,
  custom,
}

enum EffectLayerPosition { background, foreground, overlay }

const Set<String> _knownEffectLayerTokens = <String>{
  'gradient_wash',
  'gradient',
  'wash',
  'matrix_rain',
  'matrix',
  'stars',
  'starfield',
  'galaxy_stars',
  'particle_field',
  'particles',
  'radial_particles',
  'orbital_field',
  'line_field',
  'line_sweep',
  'segments',
  'orbit_field',
  'orbit',
  'rings',
  'noise_field',
  'noise',
  'grain',
  'rain',
  'rainstorm',
  'nebula',
  'galaxy',
  'water_flow',
  'flowing_water',
  'liquid_dream',
  'liquid_glow',
  'shader',
  'lottie',
  'rive',
};

String normalizeEffectLayerToken(Object? value) {
  if (value == null) return '';
  return value
      .toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
}

EffectLayerPosition _parseEffectLayerPosition(Object? value) {
  final normalized = normalizeEffectLayerToken(value);
  switch (normalized) {
    case 'foreground':
    case 'front':
    case 'content':
      return EffectLayerPosition.foreground;
    case 'overlay':
    case 'top':
      return EffectLayerPosition.overlay;
    default:
      return EffectLayerPosition.background;
  }
}

bool looksLikeEffectLayerValue(Object? raw) {
  if (raw == null) return false;
  if (raw is EffectLayer) return true;
  if (raw is String) {
    return _knownEffectLayerTokens.contains(normalizeEffectLayerToken(raw));
  }
  if (raw is! Map) return false;
  final config = coerceObjectMap(raw);
  if (config.isEmpty) return false;
  if (config['shader_asset'] != null ||
      config['lottie_asset'] != null ||
      config['lottie_url'] != null ||
      config['lottie_data'] != null ||
      config['lottie_json'] != null ||
      config['rive_asset'] != null ||
      config['rive_url'] != null ||
      config['uniforms'] != null ||
      config['region'] != null ||
      config['bounds'] != null ||
      config['mask'] != null ||
      config['scene_mask'] != null ||
      config['gradient'] != null ||
      config['palette'] != null) {
    return true;
  }
  final token = normalizeEffectLayerToken(
    config['type'] ??
        config['kind'] ??
        config['preset'] ??
        config['effect'] ??
        config['scene'],
  );
  if (_knownEffectLayerTokens.contains(token)) {
    return true;
  }
  final renderer = normalizeEffectLayerToken(config['renderer']);
  return renderer == 'shader';
}

EffectLayerKind _parseEffectLayerKind(Map<String, Object?> config) {
  final renderer = normalizeEffectLayerToken(config['renderer']);
  if (renderer == 'shader' || config['shader_asset'] != null) {
    return EffectLayerKind.shader;
  }
  final normalized = normalizeEffectLayerToken(
    config['type'] ??
        config['kind'] ??
        config['preset'] ??
        config['effect'] ??
        config['scene'],
  );
  switch (normalized) {
    case 'gradient_wash':
    case 'gradient':
    case 'wash':
      return EffectLayerKind.gradientWash;
    case 'matrix_rain':
    case 'matrix':
      return EffectLayerKind.matrixRain;
    case 'stars':
    case 'starfield':
    case 'galaxy_stars':
      return EffectLayerKind.starfield;
    case 'particle_field':
    case 'particles':
    case 'radial_particles':
    case 'orbital_field':
      return EffectLayerKind.particleField;
    case 'line_field':
    case 'line_sweep':
    case 'segments':
      return EffectLayerKind.lineField;
    case 'orbit_field':
    case 'orbit':
    case 'rings':
      return EffectLayerKind.orbitField;
    case 'noise_field':
    case 'noise':
    case 'grain':
      return EffectLayerKind.noiseField;
    case 'rain':
    case 'rainstorm':
      return EffectLayerKind.rain;
    case 'nebula':
    case 'galaxy':
      return EffectLayerKind.nebula;
    case 'water_flow':
    case 'flowing_water':
    case 'liquid_dream':
    case 'liquid_glow':
      return EffectLayerKind.liquidGlow;
    case 'lottie':
    case 'rive':
      return EffectLayerKind.asset;
    default:
      if (config['lottie_asset'] != null ||
          config['lottie_url'] != null ||
          config['lottie_data'] != null ||
          config['lottie_json'] != null ||
          config['rive_asset'] != null ||
          config['rive_url'] != null) {
        return EffectLayerKind.asset;
      }
      return EffectLayerKind.custom;
  }
}

class EffectLayer {
  final EffectLayerKind kind;
  final EffectLayerPosition position;
  final Map<String, Object?> config;
  final String normalizedType;
  final double opacity;
  final double speed;
  final double density;
  final double intensity;
  final Color? color;
  final Color? accentColor;

  const EffectLayer({
    required this.kind,
    required this.position,
    required this.config,
    required this.normalizedType,
    required this.opacity,
    required this.speed,
    required this.density,
    required this.intensity,
    required this.color,
    required this.accentColor,
  });

  static EffectLayer? fromValue(
    Object? raw, {
    EffectLayerPosition? defaultPosition,
  }) {
    if (raw == null) return null;
    if (raw is EffectLayer) return raw;

    Map<String, Object?> config;
    if (raw is String) {
      config = <String, Object?>{'type': raw};
    } else if (raw is Map) {
      config = coerceObjectMap(raw);
    } else {
      return null;
    }
    if (config.isEmpty || !looksLikeEffectLayerValue(config)) return null;

    final position =
        defaultPosition ??
        _parseEffectLayerPosition(config['position'] ?? config['layer']);
    final kind = _parseEffectLayerKind(config);
    return EffectLayer(
      kind: kind,
      position: position,
      config: Map<String, Object?>.from(config),
      normalizedType: normalizeEffectLayerToken(
        config['type'] ??
            config['kind'] ??
            config['preset'] ??
            config['effect'] ??
            config['scene'],
      ),
      opacity: (coerceDouble(config['opacity']) ?? 1.0).clamp(0.0, 1.0),
      speed: (coerceDouble(config['speed']) ?? 0.45).clamp(0.05, 4.0),
      density: (coerceDouble(config['density']) ?? 0.7).clamp(0.05, 2.0),
      intensity: (coerceDouble(config['intensity']) ?? 0.8).clamp(0.05, 2.0),
      color: coerceColor(config['color']),
      accentColor:
          coerceColor(config['accent_color']) ??
          coerceColor(config['accentColor']),
    );
  }

  bool get usesAssetRenderer =>
      kind == EffectLayerKind.asset ||
      config['lottie_asset'] != null ||
      config['lottie_url'] != null ||
      config['lottie_data'] != null ||
      config['lottie_json'] != null ||
      config['rive_asset'] != null ||
      config['rive_url'] != null;

  bool get usesShaderRenderer =>
      kind == EffectLayerKind.shader ||
      config['shader_asset'] != null ||
      normalizeEffectLayerToken(config['renderer']) == 'shader';

  bool get usesPainterRenderer =>
      kind == EffectLayerKind.gradientWash ||
      kind == EffectLayerKind.matrixRain ||
      kind == EffectLayerKind.starfield ||
      kind == EffectLayerKind.particleField ||
      kind == EffectLayerKind.lineField ||
      kind == EffectLayerKind.orbitField ||
      kind == EffectLayerKind.noiseField ||
      kind == EffectLayerKind.rain ||
      kind == EffectLayerKind.nebula ||
      kind == EffectLayerKind.liquidGlow;

  String get signature =>
      jsonEncode(<String, Object?>{
        'position': position.name,
        'type': normalizedType,
        'opacity': opacity.toStringAsFixed(3),
        'speed': speed.toStringAsFixed(3),
        'density': density.toStringAsFixed(3),
        'intensity': intensity.toStringAsFixed(3),
        'color': color?.toARGB32(),
        'accent_color': accentColor?.toARGB32(),
        'config': _stableSignatureValue(config),
      });
}

Object? _stableSignatureValue(Object? value) {
  if (value == null || value is num || value is bool || value is String) {
    return value;
  }
  if (value is Color) {
    return value.toARGB32();
  }
  if (value is Map) {
    final sortedKeys = value.keys.map((key) => key.toString()).toList()..sort();
    return <String, Object?>{
      for (final key in sortedKeys)
        key: _stableSignatureValue(value[key]),
    };
  }
  if (value is Iterable) {
    return value.map(_stableSignatureValue).toList(growable: false);
  }
  return value.toString();
}
