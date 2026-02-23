import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildVectorViewControl(Map<String, Object?> props) {
  final width = coerceDouble(props['width']) ?? 120;
  final height = coerceDouble(props['height']) ?? 120;
  final background = parseColor(props['background_color']) ?? Colors.transparent;
  final shape = (props['shape'] ?? 'rect').toString();
  final fill = parseColor(props['fill']) ?? Colors.blue;

  Widget child;
  switch (shape) {
    case 'circle':
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          shape: BoxShape.circle,
        ),
      );
      break;
    case 'triangle':
      child = CustomPaint(
        painter: _TrianglePainter(
          color: fill,
          stroke: parseColor(props['stroke']) ?? Colors.transparent,
          strokeWidth: coerceDouble(props['stroke_width']) ?? 0,
        ),
      );
      break;
    case 'rect':
    default:
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(
            color: parseColor(props['stroke']) ?? Colors.transparent,
            width: coerceDouble(props['stroke_width']) ?? 0,
          ),
        ),
      );
      break;
  }

  return Container(
    width: width,
    height: height,
    color: background,
    child: child,
  );
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    required this.color,
    required this.stroke,
    required this.strokeWidth,
  });

  final Color color;
  final Color stroke;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path, fillPaint);

    if (strokeWidth > 0) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = stroke;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.stroke != stroke ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
