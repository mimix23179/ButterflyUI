import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/scene/candy_layer.dart';

double _fract(double value) => value - value.floorToDouble();

double _seed(int index, [double offset = 0]) {
  final value = math.sin((index + 1) * 12.9898 + offset * 78.233) * 43758.5453;
  return _fract(value.abs());
}

Color _withOpacity(Color color, double opacity) {
  return color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}

class _MatrixRainPainter extends CustomPainter {
  final CandySceneLayer layer;
  final double progress;

  const _MatrixRainPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
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
          (_fract(progress * layer.speed * 1.35 + seed) * travel) -
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

class _StarfieldPainter extends CustomPainter {
  final CandySceneLayer layer;
  final double progress;

  const _StarfieldPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final starCount = math.max(36, (140 * layer.density).round());
    final color = layer.color ?? const Color(0xFFEAF9FF);
    final accent = layer.accentColor ?? const Color(0xFF7DDCFF);
    for (var index = 0; index < starCount; index++) {
      final seedX = _seed(index, 0.1);
      final seedY = _seed(index, 0.7);
      final seedT = _seed(index, 1.3);
      final twinkle =
          0.45 +
          (math.sin((progress * layer.speed * 6) + seedT * math.pi * 2) + 1) *
              0.25;
      final radius = 0.6 + _seed(index, 2.1) * 1.9 * layer.intensity;
      final dx = seedX * size.width;
      final dy =
          _fract(seedY + progress * layer.speed * (0.02 + seedX * 0.05)) *
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

class _RainPainter extends CustomPainter {
  final CandySceneLayer layer;
  final double progress;

  const _RainPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
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
          _fract(seedY + progress * layer.speed * (0.55 + seedX * 0.2)) *
              (size.height + length) -
          length;
      canvas.drawLine(Offset(dx, dy), Offset(dx + slant, dy + length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) => true;
}

class _NebulaPainter extends CustomPainter {
  final CandySceneLayer layer;
  final double progress;

  const _NebulaPainter({required this.layer, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
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
      final drift = math.sin(progress * layer.speed * math.pi * 2 + index) * 18;
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

Widget? buildCandyScenePaintLayer(
  CandySceneLayer layer, {
  required double progress,
}) {
  final painter = switch (layer.kind) {
    CandySceneLayerKind.matrixRain => _MatrixRainPainter(
      layer: layer,
      progress: progress,
    ),
    CandySceneLayerKind.starfield => _StarfieldPainter(
      layer: layer,
      progress: progress,
    ),
    CandySceneLayerKind.rain => _RainPainter(layer: layer, progress: progress),
    CandySceneLayerKind.nebula => _NebulaPainter(
      layer: layer,
      progress: progress,
    ),
    _ => null,
  };
  if (painter == null) return null;
  return Positioned.fill(
    child: IgnorePointer(
      child: Opacity(
        opacity: layer.opacity,
        child: RepaintBoundary(
          child: CustomPaint(painter: painter, child: const SizedBox.expand()),
        ),
      ),
    ),
  );
}
