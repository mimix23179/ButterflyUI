import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

enum CandySceneLayerKind { matrixRain, starfield, rain, nebula, asset, custom }

enum CandySceneLayerPosition { background, overlay }

String normalizeCandySceneLayerToken(Object? value) {
  if (value == null) return '';
  return value
      .toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
}

CandySceneLayerPosition _parseCandySceneLayerPosition(Object? value) {
  final normalized = normalizeCandySceneLayerToken(value);
  switch (normalized) {
    case 'overlay':
    case 'foreground':
    case 'front':
      return CandySceneLayerPosition.overlay;
    default:
      return CandySceneLayerPosition.background;
  }
}

CandySceneLayerKind _parseCandySceneLayerKind(Map<String, Object?> config) {
  final normalized = normalizeCandySceneLayerToken(
    config['type'] ??
        config['kind'] ??
        config['preset'] ??
        config['effect'] ??
        config['scene'],
  );
  switch (normalized) {
    case 'matrix_rain':
    case 'matrix':
      return CandySceneLayerKind.matrixRain;
    case 'stars':
    case 'starfield':
    case 'galaxy_stars':
      return CandySceneLayerKind.starfield;
    case 'rain':
    case 'rainstorm':
      return CandySceneLayerKind.rain;
    case 'nebula':
    case 'galaxy':
    case 'water_flow':
    case 'flowing_water':
    case 'liquid_dream':
      return CandySceneLayerKind.nebula;
    case 'lottie':
    case 'rive':
      return CandySceneLayerKind.asset;
    default:
      if (config['lottie_asset'] != null ||
          config['lottie_url'] != null ||
          config['lottie_data'] != null ||
          config['lottie_json'] != null ||
          config['rive_asset'] != null ||
          config['rive_url'] != null) {
        return CandySceneLayerKind.asset;
      }
      return CandySceneLayerKind.custom;
  }
}

class CandySceneLayer {
  final CandySceneLayerKind kind;
  final CandySceneLayerPosition position;
  final Map<String, Object?> config;
  final String normalizedType;
  final double opacity;
  final double speed;
  final double density;
  final double intensity;
  final Color? color;
  final Color? accentColor;

  const CandySceneLayer({
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

  static CandySceneLayer? fromValue(
    Object? raw, {
    CandySceneLayerPosition? defaultPosition,
  }) {
    if (raw == null) return null;
    if (raw is CandySceneLayer) return raw;

    Map<String, Object?> config;
    if (raw is String) {
      config = <String, Object?>{'type': raw};
    } else if (raw is Map) {
      config = coerceObjectMap(raw);
    } else {
      return null;
    }
    if (config.isEmpty) return null;

    final position =
        defaultPosition ??
        _parseCandySceneLayerPosition(config['position'] ?? config['layer']);
    final kind = _parseCandySceneLayerKind(config);
    return CandySceneLayer(
      kind: kind,
      position: position,
      config: Map<String, Object?>.from(config),
      normalizedType: normalizeCandySceneLayerToken(
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
      kind == CandySceneLayerKind.asset ||
      config['lottie_asset'] != null ||
      config['lottie_url'] != null ||
      config['lottie_data'] != null ||
      config['lottie_json'] != null ||
      config['rive_asset'] != null ||
      config['rive_url'] != null;

  bool get usesPainterRenderer =>
      kind == CandySceneLayerKind.matrixRain ||
      kind == CandySceneLayerKind.starfield ||
      kind == CandySceneLayerKind.rain ||
      kind == CandySceneLayerKind.nebula;

  String get signature =>
      '${position.name}:$normalizedType:${config['lottie_asset'] ?? config['rive_asset'] ?? config['lottie_url'] ?? config['rive_url'] ?? ''}:${color?.toARGB32() ?? ''}:${accentColor?.toARGB32() ?? ''}:${speed.toStringAsFixed(2)}:${density.toStringAsFixed(2)}:${intensity.toStringAsFixed(2)}';
}
