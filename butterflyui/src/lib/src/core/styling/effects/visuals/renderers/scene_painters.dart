import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/layer.dart';

double _fract(double value) => value - value.floorToDouble();

double _layerProgress(EffectLayer layer, double progress) {
  final phase = (coerceDouble(layer.config['phase']) ?? 0.0).clamp(0.0, 1.0);
  return _fract(progress + phase);
}

double _seed(int index, [double offset = 0]) {
  final value = math.sin((index + 1) * 12.9898 + offset * 78.233) * 43758.5453;
  return _fract(value.abs());
}

Color _withOpacity(Color color, double opacity) {
  return color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}

class _MatrixRainPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _MatrixRainPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final columnCount = math.max(10, (size.width / 28 * layer.density).round());
    final trailLength = math.max(6, (8 + layer.intensity * 10).round());
    final glyphHeight = 10 + layer.intensity * 6;
    final strokeWidth = math.max(1.5, size.width / columnCount * 0.16);
    final headColor = layer.accentColor ?? const Color(0xFFD5FFE8);
    final trailColor = layer.color ?? const Color(0xFF2BFFB0);

    for (var column = 0; column < columnCount; column++) {
      final seed = _seed(column, layer.speed);
      final x = ((column + 0.5) / columnCount) * size.width;
      final travel = size.height + trailLength * glyphHeight;
      final yBase =
          (_fract(layerProgress * layer.speed * 1.35 + seed) * travel) -
          trailLength * glyphHeight;
      for (var index = 0; index < trailLength; index++) {
        final alpha = math.max(0.0, 1 - (index / trailLength));
        final color = Color.lerp(
          headColor,
          trailColor,
          math.min(1, index / trailLength),
        )!;
        final paint = Paint()
          ..color = _withOpacity(color, alpha * 0.75)
          ..style = PaintingStyle.fill;
        final top = yBase - index * glyphHeight;
        if (top > size.height || top + glyphHeight < 0) continue;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, top, strokeWidth, glyphHeight - 2),
            const Radius.circular(2),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixRainPainter oldDelegate) => true;
}

class _GradientWashPainter extends CustomPainter {
  final EffectLayer layer;

  const _GradientWashPainter({required this.layer});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rawGradient = layer.config['gradient'];
    final gradient = coerceGradient(rawGradient);
    final paint = Paint()
      ..shader =
          gradient?.createShader(rect) ??
          RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: <Color>[
              _withOpacity(layer.color ?? const Color(0xFFFFFFFF), 0.9),
              _withOpacity(layer.accentColor ?? const Color(0xFFF1F5F9), 0.0),
            ],
          ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientWashPainter oldDelegate) => true;
}

class _StarfieldPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _StarfieldPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final starCount = math.max(36, (140 * layer.density).round());
    final color = layer.color ?? const Color(0xFFEAF9FF);
    final accent = layer.accentColor ?? const Color(0xFF7DDCFF);
    for (var index = 0; index < starCount; index++) {
      final seedX = _seed(index, 0.1);
      final seedY = _seed(index, 0.7);
      final seedT = _seed(index, 1.3);
      final twinkle =
          0.45 +
          (math.sin((layerProgress * layer.speed * 6) + seedT * math.pi * 2) + 1) *
              0.25;
      final radius = 0.6 + _seed(index, 2.1) * 1.9 * layer.intensity;
      final dx = seedX * size.width;
      final dy =
          _fract(seedY + layerProgress * layer.speed * (0.02 + seedX * 0.05)) *
          size.height;
      final paint = Paint()
        ..color = _withOpacity(
          Color.lerp(color, accent, _seed(index, 3.4))!,
          twinkle.clamp(0.15, 0.95),
        );
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}

class _ParticleFieldPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _ParticleFieldPainter({required this.layer, required this.progress});

  List<Color> _palette() {
    final raw = layer.config['palette'];
    if (raw is List) {
      final colors = raw
          .map((value) => coerceColor(value))
          .whereType<Color>()
          .toList();
      if (colors.isNotEmpty) return colors;
    }
    return <Color>[
      layer.color ?? const Color(0xFF3B82F6),
      layer.accentColor ?? const Color(0xFF7C3AED),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final particleCount =
        coerceOptionalInt(layer.config['count']) ??
        math.max(120, (260 * layer.density).round());
    final length =
        (coerceDouble(layer.config['length']) ?? (8 + layer.intensity * 10))
            .clamp(3.0, 36.0);
    final thickness =
        (coerceDouble(layer.config['thickness']) ?? (1.5 + layer.intensity * 1.4))
            .clamp(0.8, 6.0);
    final rotation = coerceDouble(layer.config['rotation']) ?? 0.55;
    final drift = coerceDouble(layer.config['drift']) ?? 0.18;
    final spread = normalizeEffectLayerToken(layer.config['spread']);
    final centerRaw = layer.config['center'];
    final center = centerRaw is Map
        ? Offset(
            (coerceDouble(coerceObjectMap(centerRaw)['x']) ?? 0.5) * size.width,
            (coerceDouble(coerceObjectMap(centerRaw)['y']) ?? 0.42) * size.height,
          )
        : Offset(size.width * 0.5, size.height * 0.42);
    final palette = _palette();

    for (var index = 0; index < particleCount; index++) {
      final seedA = _seed(index, 0.2);
      final seedB = _seed(index, 0.7);
      final seedC = _seed(index, 1.4);
      final orbit = layerProgress * layer.speed * 0.35 + seedC * math.pi * 2;
      final angle =
          (seedA * math.pi * 2) +
          (spread == 'spiral' ? orbit : orbit * 0.45) +
          rotation;
      final radial = spread == 'ring'
          ? math.max(size.width, size.height) * (0.18 + seedB * 0.34)
          : math.pow(seedB, 0.78).toDouble() *
                math.max(size.width, size.height) *
                0.58;
      final driftX = math.cos(orbit + seedA * 8) * drift * 42;
      final driftY = math.sin(orbit * 1.2 + seedB * 9) * drift * 30;
      final dx = center.dx + math.cos(angle) * radial + driftX;
      final dy = center.dy + math.sin(angle) * radial * 0.72 + driftY;
      final color = palette[index % palette.length];
      final paint = Paint()
        ..color = _withOpacity(color, 0.52 + (seedC * 0.35))
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness * (0.75 + seedA * 0.65);
      final segmentAngle = angle + math.pi * 0.5;
      final half = length * (0.7 + seedB * 0.55);
      canvas.drawLine(
        Offset(
          dx - math.cos(segmentAngle) * half,
          dy - math.sin(segmentAngle) * half,
        ),
        Offset(
          dx + math.cos(segmentAngle) * half,
          dy + math.sin(segmentAngle) * half,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) => true;
}

class _LineFieldPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _LineFieldPainter({required this.layer, required this.progress});

  List<Color> _palette() {
    final raw = layer.config['palette'];
    if (raw is List) {
      final colors = raw
          .map((value) => coerceColor(value))
          .whereType<Color>()
          .toList(growable: false);
      if (colors.isNotEmpty) return colors;
    }
    return <Color>[
      layer.color ?? const Color(0xFF3B82F6),
      layer.accentColor ?? const Color(0xFF7C3AED),
      const Color(0xFFF43F5E),
      const Color(0xFFF59E0B),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final count =
        coerceOptionalInt(layer.config['count']) ??
        math.max(42, (120 * layer.density).round());
    final thickness =
        (coerceDouble(layer.config['thickness']) ?? (1.1 + layer.intensity))
            .clamp(0.6, 4.0);
    final length =
        (coerceDouble(layer.config['length']) ?? 22.0 + layer.intensity * 14)
            .clamp(4.0, 48.0);
    final direction = normalizeEffectLayerToken(layer.config['direction']);
    final palette = _palette();
    final tilt = direction == 'vertical'
        ? math.pi * 0.5
        : direction == 'diagonal'
        ? 0.9
        : 0.22;

    for (var index = 0; index < count; index++) {
      final seedA = _seed(index, 11.2);
      final seedB = _seed(index, 12.3);
      final seedC = _seed(index, 13.4);
      final dx = seedA * size.width;
      final dy = _fract(seedB + layerProgress * layer.speed * 0.15) * size.height;
      final angle =
          tilt + math.sin(layerProgress * layer.speed + seedC * 7) * 0.12;
      final half = length * (0.7 + seedC * 0.6);
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness * (0.85 + seedB * 0.45)
        ..color = _withOpacity(
          palette[index % palette.length],
          0.25 + seedC * 0.45,
        );
      canvas.drawLine(
        Offset(dx - math.cos(angle) * half, dy - math.sin(angle) * half),
        Offset(dx + math.cos(angle) * half, dy + math.sin(angle) * half),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineFieldPainter oldDelegate) => true;
}

class _OrbitFieldPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _OrbitFieldPainter({required this.layer, required this.progress});

  List<Color> _palette() {
    final raw = layer.config['palette'];
    if (raw is List) {
      final colors = raw
          .map((value) => coerceColor(value))
          .whereType<Color>()
          .toList(growable: false);
      if (colors.isNotEmpty) return colors;
    }
    return <Color>[
      layer.color ?? const Color(0xFF2563EB),
      layer.accentColor ?? const Color(0xFF8B5CF6),
      const Color(0xFFF43F5E),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final centerRaw = layer.config['center'];
    final center = centerRaw is Map
        ? Offset(
            (coerceDouble(coerceObjectMap(centerRaw)['x']) ?? 0.5) * size.width,
            (coerceDouble(coerceObjectMap(centerRaw)['y']) ?? 0.42) * size.height,
          )
        : Offset(size.width * 0.5, size.height * 0.42);
    final baseRadius =
        (coerceDouble(layer.config['radius']) ?? size.shortestSide * 0.16)
            .clamp(40.0, size.shortestSide * 0.45);
    final bandWidth =
        (coerceDouble(layer.config['band_width']) ?? size.shortestSide * 0.22)
            .clamp(12.0, size.shortestSide * 0.46);
    final count =
        coerceOptionalInt(layer.config['count']) ??
        math.max(28, (68 * layer.density).round());
    final markerSize =
        (coerceDouble(layer.config['marker_size']) ?? 5.0 + layer.intensity * 2.0)
            .clamp(2.0, 16.0);
    final swirl = coerceDouble(layer.config['swirl']) ?? 0.75;
    final palette = _palette();

    for (var index = 0; index < count; index++) {
      final seedA = _seed(index, 14.1);
      final seedB = _seed(index, 15.1);
      final seedC = _seed(index, 16.1);
      final ringRadius = baseRadius + bandWidth * seedB;
      final orbit = layerProgress * layer.speed * (0.18 + seedA * 0.22);
      final angle = (seedA * math.pi * 2) + orbit * swirl;
      final dx = center.dx + math.cos(angle) * ringRadius;
      final dy = center.dy + math.sin(angle) * ringRadius * 0.72;
      final paint = Paint()
        ..color = _withOpacity(
          palette[index % palette.length],
          0.24 + seedC * 0.5,
        )
        ..strokeCap = StrokeCap.round
        ..strokeWidth = markerSize * (0.45 + seedB * 0.35);
      final segmentAngle = angle + math.pi * 0.5;
      final half = markerSize * (1.5 + seedC);
      canvas.drawLine(
        Offset(
          dx - math.cos(segmentAngle) * half,
          dy - math.sin(segmentAngle) * half,
        ),
        Offset(
          dx + math.cos(segmentAngle) * half,
          dy + math.sin(segmentAngle) * half,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitFieldPainter oldDelegate) => true;
}

class _NoiseFieldPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _NoiseFieldPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final count =
        coerceOptionalInt(layer.config['count']) ??
        math.max(180, (420 * layer.density).round());
    final scale =
        (coerceDouble(layer.config['scale']) ?? 1.0 + layer.intensity * 0.4)
            .clamp(0.2, 3.0);
    final contrast =
        (coerceDouble(layer.config['contrast']) ?? 0.35 + layer.intensity * 0.2)
            .clamp(0.05, 1.0);
    final base = layer.color ?? const Color(0xFF111827);
    final accent = layer.accentColor ?? const Color(0xFF475569);

    for (var index = 0; index < count; index++) {
      final seedA = _seed(index, 17.0 + layerProgress * layer.speed);
      final seedB = _seed(index, 18.0);
      final seedC = _seed(index, 19.0);
      final dx = seedA * size.width;
      final dy = seedB * size.height;
      final radius = (0.4 + seedC * 1.8) * scale;
      final paint = Paint()
        ..color = _withOpacity(
          Color.lerp(base, accent, seedC)!,
          0.03 + contrast * 0.10 * seedA,
        );
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoiseFieldPainter oldDelegate) => true;
}

class _RainPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _RainPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final dropCount = math.max(40, (120 * layer.density).round());
    final paint = Paint()
      ..color = _withOpacity(
        layer.color ?? const Color(0xFFA7DBFF),
        0.35 + layer.intensity * 0.22,
      )
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4 + layer.intensity * 0.8;
    final length = 18 + layer.intensity * 18;
    final slant = 10 + layer.intensity * 14;
    for (var index = 0; index < dropCount; index++) {
      final seedX = _seed(index, 4.1);
      final seedY = _seed(index, 5.3);
      final dx = seedX * (size.width + slant) - slant;
      final dy =
          _fract(seedY + layerProgress * layer.speed * (0.55 + seedX * 0.2)) *
              (size.height + length) -
          length;
      canvas.drawLine(Offset(dx, dy), Offset(dx + slant, dy + length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) => true;
}

class _NebulaPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _NebulaPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final rect = Offset.zero & size;
    final base = layer.color ?? const Color(0xFF24104B);
    final accent = layer.accentColor ?? const Color(0xFF46C8FF);
    final wash = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          _withOpacity(base, 0.28),
          _withOpacity(accent, 0.18),
          _withOpacity(base, 0.12),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, wash);

    final cloudCount = math.max(3, (5 * layer.density).round());
    for (var index = 0; index < cloudCount; index++) {
      final seedX = _seed(index, 6.2);
      final seedY = _seed(index, 7.4);
      final drift =
          math.sin(layerProgress * layer.speed * math.pi * 2 + index) * 18;
      final center = Offset(
        size.width * (0.12 + seedX * 0.76) + drift,
        size.height * (0.14 + seedY * 0.72) - drift * 0.35,
      );
      final radius =
          size.shortestSide *
          (0.18 + _seed(index, 8.6) * 0.24) *
          (0.65 + layer.intensity * 0.35);
      final color = Color.lerp(base, accent, _seed(index, 9.8))!;
      final paint = Paint()
        ..color = _withOpacity(color, 0.16 + _seed(index, 10.9) * 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 72);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NebulaPainter oldDelegate) => true;
}

class _LiquidGlowPainter extends CustomPainter {
  final EffectLayer layer;
  final double progress;

  const _LiquidGlowPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final layerProgress = _layerProgress(layer, progress);
    final rect = Offset.zero & size;
    final base = layer.color ?? const Color(0xFF0F4475);
    final accent = layer.accentColor ?? const Color(0xFF35D0FF);
    final path = Path();
    path.moveTo(0, size.height * 0.62);
    for (var x = 0.0; x <= size.width; x += 14) {
      final wave =
          math.sin(
                (x / size.width) * math.pi * 3 +
                    layerProgress * layer.speed * math.pi * 2,
              ) *
              (16 + layer.intensity * 22);
      path.lineTo(x, size.height * 0.58 + wave);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          _withOpacity(accent, 0.18),
          _withOpacity(base, 0.28),
          _withOpacity(base, 0.46),
        ],
      ).createShader(rect);
    final glow = Paint()
      ..color = _withOpacity(accent, 0.18 + layer.intensity * 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant _LiquidGlowPainter oldDelegate) => true;
}

CustomPainter? buildEffectScenePainter(
  EffectLayer layer, {
  required double progress,
}) {
  return switch (layer.kind) {
    EffectLayerKind.gradientWash => _GradientWashPainter(layer: layer),
    EffectLayerKind.matrixRain => _MatrixRainPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.starfield => _StarfieldPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.particleField => _ParticleFieldPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.lineField => _LineFieldPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.orbitField => _OrbitFieldPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.noiseField => _NoiseFieldPainter(
      layer: layer,
      progress: progress,
    ),
    EffectLayerKind.rain => _RainPainter(layer: layer, progress: progress),
    EffectLayerKind.nebula => _NebulaPainter(layer: layer, progress: progress),
    EffectLayerKind.liquidGlow => _LiquidGlowPainter(
      layer: layer,
      progress: progress,
    ),
    _ => null,
  };
}

Widget? buildEffectScenePaintLayer(
  EffectLayer layer, {
  required double progress,
}) {
  final painter = buildEffectScenePainter(layer, progress: progress);
  if (painter == null) return null;
  return IgnorePointer(
    child: RepaintBoundary(
      child: CustomPaint(painter: painter, child: const SizedBox.expand()),
    ),
  );
}
