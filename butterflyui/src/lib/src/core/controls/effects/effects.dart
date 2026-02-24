import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildEffectsControl(Map<String, Object?> props, Widget child) {
  if (props['enabled'] == false) return child;

  Widget built = child;

  final blur = coerceDouble(props['blur']) ?? 0.0;
  if (blur > 0) {
    built = ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: built,
    );
  }

  final color = coerceColor(props['color']);
  final blendMode = _parseBlendMode(props['blend_mode']) ?? BlendMode.srcATop;
  if (color != null) {
    built = ColorFiltered(
      colorFilter: ColorFilter.mode(color, blendMode),
      child: built,
    );
  }

  final matrix = _buildColorMatrix(props);
  if (matrix != null) {
    built = ColorFiltered(colorFilter: ColorFilter.matrix(matrix), child: built);
  }

  final opacity = coerceDouble(props['opacity']);
  if (opacity != null && opacity >= 0 && opacity < 1) {
    built = Opacity(opacity: opacity.clamp(0.0, 1.0), child: built);
  }

  return built;
}

BlendMode? _parseBlendMode(Object? value) {
  if (value == null) return null;
  switch (value.toString().toLowerCase()) {
    case 'multiply':
      return BlendMode.multiply;
    case 'screen':
      return BlendMode.screen;
    case 'overlay':
      return BlendMode.overlay;
    case 'soft_light':
    case 'softlight':
      return BlendMode.softLight;
    case 'hard_light':
    case 'hardlight':
      return BlendMode.hardLight;
    case 'difference':
      return BlendMode.difference;
    case 'plus':
      return BlendMode.plus;
    case 'modulate':
      return BlendMode.modulate;
    case 'src':
      return BlendMode.src;
    case 'src_over':
    case 'srcover':
      return BlendMode.srcOver;
    case 'src_atop':
    case 'srcatop':
      return BlendMode.srcATop;
  }
  return null;
}

List<double>? _buildColorMatrix(Map<String, Object?> props) {
  final brightness = coerceDouble(props['brightness']) ?? 1.0;
  final contrast = coerceDouble(props['contrast']) ?? 1.0;
  final saturation = coerceDouble(props['saturation']) ?? 1.0;
  final grayscale = coerceDouble(props['grayscale']) ?? 0.0;

  final changed =
      brightness != 1.0 || contrast != 1.0 || saturation != 1.0 || grayscale > 0;
  if (!changed) return null;

  final s = saturation;
  const rw = 0.2126;
  const gw = 0.7152;
  const bw = 0.0722;

  final invS = 1 - s;
  var r0 = (invS * rw) + s;
  var r1 = invS * gw;
  var r2 = invS * bw;
  var g0 = invS * rw;
  var g1 = (invS * gw) + s;
  var g2 = invS * bw;
  var b0 = invS * rw;
  var b1 = invS * gw;
  var b2 = (invS * bw) + s;

  if (grayscale > 0) {
    final g = grayscale.clamp(0.0, 1.0);
    r0 = r0 * (1 - g) + rw * g;
    r1 = r1 * (1 - g) + gw * g;
    r2 = r2 * (1 - g) + bw * g;
    g0 = g0 * (1 - g) + rw * g;
    g1 = g1 * (1 - g) + gw * g;
    g2 = g2 * (1 - g) + bw * g;
    b0 = b0 * (1 - g) + rw * g;
    b1 = b1 * (1 - g) + gw * g;
    b2 = b2 * (1 - g) + bw * g;
  }

  final c = contrast;
  final t = (1 - c) * 128;
  final bShift = (brightness - 1.0) * 255;

  return <double>[
    r0 * c, r1 * c, r2 * c, 0, t + bShift,
    g0 * c, g1 * c, g2 * c, 0, t + bShift,
    b0 * c, b1 * c, b2 * c, 0, t + bShift,
    0, 0, 0, 1, 0,
  ];
}
