import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPiePlotControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final values = _coerceValues(props['values']);
  final labels = _coerceLabels(props['labels']);
  final colors = _coerceColors(props['colors']);
  final donut = props['donut'] == true;
  final hole = (coerceDouble(props['hole']) ?? 0.55).clamp(0.0, 0.9);
  final startAngle = (coerceDouble(props['start_angle']) ?? -90.0) * math.pi / 180.0;

  if (values.isEmpty) {
    return const SizedBox.shrink();
  }

  return GestureDetector(
    onTapDown: controlId.isEmpty
        ? null
        : (details) {
            sendEvent(controlId, 'tap', {
              'x': details.localPosition.dx,
              'y': details.localPosition.dy,
            });
          },
    child: AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _PiePainter(
          values: values,
          colors: colors,
          donut: donut,
          hole: hole,
          startAngle: startAngle,
        ),
        child: Center(
          child: Text(
            labels.isNotEmpty ? labels.first : '',
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

class _PiePainter extends CustomPainter {
  const _PiePainter({
    required this.values,
    required this.colors,
    required this.donut,
    required this.hole,
    required this.startAngle,
  });

  final List<double> values;
  final List<Color> colors;
  final bool donut;
  final double hole;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final total = values.fold<double>(0, (sum, item) => sum + item.abs());
    if (total <= 0) return;

    var angle = startAngle;
    for (var i = 0; i < values.length; i += 1) {
      final sweep = (values[i].abs() / total) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i % colors.length];
      canvas.drawArc(rect, angle, sweep, true, paint);
      angle += sweep;
    }

    if (donut || hole > 0) {
      final holePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white;
      canvas.drawCircle(center, radius * hole, holePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.colors != colors ||
        oldDelegate.donut != donut ||
        oldDelegate.hole != hole ||
        oldDelegate.startAngle != startAngle;
  }
}

List<double> _coerceValues(Object? raw) {
  if (raw is! List) return const <double>[];
  final out = <double>[];
  for (final item in raw) {
    final value = coerceDouble(item);
    if (value != null) out.add(value);
  }
  return out;
}

List<String> _coerceLabels(Object? raw) {
  if (raw is! List) return const <String>[];
  final out = <String>[];
  for (final item in raw) {
    out.add(item?.toString() ?? '');
  }
  return out;
}

List<Color> _coerceColors(Object? raw) {
  if (raw is List) {
    final out = <Color>[];
    for (final item in raw) {
      final color = coerceColor(item);
      if (color != null) out.add(color);
    }
    if (out.isNotEmpty) return out;
  }
  return const <Color>[
    Color(0xff2563eb),
    Color(0xff7c3aed),
    Color(0xffea580c),
    Color(0xff059669),
    Color(0xffdb2777),
  ];
}
