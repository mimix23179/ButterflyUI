import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

List<double> _coercePoints(Object? raw) {
  if (raw is! List) return const [];
  final out = <double>[];
  for (final item in raw) {
    if (item is num) {
      out.add(item.toDouble());
      continue;
    }
    if (item is Map) {
      final map = coerceObjectMap(item);
      final value = coerceDouble(map['y'] ?? map['value']);
      if (value != null) out.add(value);
      continue;
    }
    final value = coerceDouble(item);
    if (value != null) out.add(value);
  }
  return out;
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;
  final bool fill;

  const _LineChartPainter({
    required this.points,
    required this.color,
    required this.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minY = points.reduce(math.min);
    final maxY = points.reduce(math.max);
    final span = (maxY - minY).abs() < 0.0001 ? 1.0 : (maxY - minY);
    final stepX = points.length <= 1 ? size.width : size.width / (points.length - 1);

    final path = Path();
    for (var i = 0; i < points.length; i += 1) {
      final x = stepX * i;
      final t = (points[i] - minY) / span;
      final y = size.height - (t * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: 0.2);
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.fill != fill;
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const _BarChartPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxY = points.reduce(math.max);
    final minY = points.reduce(math.min);
    final span = (maxY - minY).abs() < 0.0001 ? 1.0 : (maxY - minY);
    final barWidth = size.width / points.length;

    final paint = Paint()..color = color;
    for (var i = 0; i < points.length; i += 1) {
      final t = (points[i] - minY) / span;
      final h = math.max(2.0, t * size.height);
      final rect = Rect.fromLTWH(
        i * barWidth + 2,
        size.height - h,
        math.max(2.0, barWidth - 4),
        h,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

Widget buildChartControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final points = _coercePoints(props['points'] ?? props['values'] ?? props['data']);
  final color = coerceColor(props['color']) ?? const Color(0xff4f46e5);
  final bgColor = coerceColor(props['background']) ?? Colors.transparent;
  final chartType = (props['chart_type'] ?? props['type'] ?? 'line')
      .toString()
      .toLowerCase();
  final height = coerceDouble(props['height']) ?? 180;
  final fill = props['fill'] == true || chartType == 'area';

  Widget chart;
  if (points.isEmpty) {
    chart = Center(
      child: Text((props['empty_label'] ?? 'No chart data').toString()),
    );
  } else if (chartType == 'bar' || chartType == 'column') {
    chart = CustomPaint(
      painter: _BarChartPainter(points: points, color: color),
      size: Size(double.infinity, height),
    );
  } else {
    chart = CustomPaint(
      painter: _LineChartPainter(points: points, color: color, fill: fill),
      size: Size(double.infinity, height),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : 1.0;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: points.isEmpty
            ? null
            : (details) {
                final ratio = (details.localPosition.dx / width).clamp(0.0, 1.0);
                final index = (ratio * (points.length - 1)).round();
                sendEvent(controlId, 'select', {
                  'index': index,
                  'value': points[index],
                });
              },
        child: Container(
          height: height,
          color: bgColor,
          child: SizedBox.expand(child: chart),
        ),
      );
    },
  );
}

Widget buildSparklineControl(Map<String, Object?> props) {
  final points = _coercePoints(props['points'] ?? props['values'] ?? props['data']);
  final color = coerceColor(props['color']) ?? const Color(0xff4f46e5);
  final height = coerceDouble(props['height']) ?? 40;
  final fill = props['fill'] == true;

  return SizedBox(
    height: height,
    child: points.isEmpty
        ? const SizedBox.shrink()
        : CustomPaint(
            painter: _LineChartPainter(points: points, color: color, fill: fill),
            size: Size.infinite,
          ),
  );
}
