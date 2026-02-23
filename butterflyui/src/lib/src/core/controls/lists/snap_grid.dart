import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSnapGridControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  Widget? child;
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildFromControl(coerceObjectMap(raw));
      break;
    }
  }

  final spacing = (coerceDouble(props['spacing']) ?? 16).clamp(2.0, 200.0);
  final subdivisions = (coerceOptionalInt(props['subdivisions']) ?? 1).clamp(1, 16);
  final lineColor =
      coerceColor(props['line_color']) ?? const Color(0x22FFFFFF);
  final majorLineColor =
      coerceColor(props['major_line_color']) ?? const Color(0x44FFFFFF);
  final background = coerceColor(props['background']);
  final lineWidth = (coerceDouble(props['line_width']) ?? 1.0).clamp(0.25, 8.0);
  final majorLineWidth =
      (coerceDouble(props['major_line_width']) ?? 1.2).clamp(0.25, 8.0);
  final showGrid = props['show_grid'] == null ? true : (props['show_grid'] == true);
  final emitOnPress = props['emit_on_press'] == true;
  final emitOnDrag = props['emit_on_drag'] == true;
  final emitOnHover = props['emit_on_hover'] == true;

  return MouseRegion(
    onHover: (event) {
      if (!emitOnHover || controlId.isEmpty) return;
      sendEvent(controlId, 'hover', {
        'x': event.localPosition.dx,
        'y': event.localPosition.dy,
      });
    },
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        if (!emitOnPress || controlId.isEmpty) return;
        sendEvent(controlId, 'press', {
          'x': details.localPosition.dx,
          'y': details.localPosition.dy,
        });
      },
      onPanUpdate: (details) {
        if (!emitOnDrag || controlId.isEmpty) return;
        sendEvent(controlId, 'drag', {
          'x': details.localPosition.dx,
          'y': details.localPosition.dy,
          'dx': details.delta.dx,
          'dy': details.delta.dy,
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final finiteWidth = constraints.maxWidth.isFinite;
          final finiteHeight = constraints.maxHeight.isFinite;
          final base = child ?? const SizedBox.shrink();
          Widget body = Stack(
            fit: StackFit.expand,
            children: [
              if (background != null) ColoredBox(color: background),
              if (showGrid)
                CustomPaint(
                  painter: _GridPainter(
                    spacing: spacing,
                    subdivisions: subdivisions,
                    lineColor: lineColor,
                    majorLineColor: majorLineColor,
                    lineWidth: lineWidth,
                    majorLineWidth: majorLineWidth,
                  ),
                ),
              base,
            ],
          );
          if (!finiteWidth || !finiteHeight) {
            body = SizedBox(
              width: finiteWidth ? null : 240,
              height: finiteHeight ? null : 160,
              child: body,
            );
          }
          return body;
        },
      ),
    ),
  );
}

class _GridPainter extends CustomPainter {
  final double spacing;
  final int subdivisions;
  final Color lineColor;
  final Color majorLineColor;
  final double lineWidth;
  final double majorLineWidth;

  _GridPainter({
    required this.spacing,
    required this.subdivisions,
    required this.lineColor,
    required this.majorLineColor,
    required this.lineWidth,
    required this.majorLineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final small = spacing / subdivisions;
    final minorPaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;
    final majorPaint = Paint()
      ..color = majorLineColor
      ..strokeWidth = majorLineWidth;

    var column = 0;
    for (double x = 0; x <= size.width; x += small) {
      final major = column % subdivisions == 0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        major ? majorPaint : minorPaint,
      );
      column += 1;
    }

    var row = 0;
    for (double y = 0; y <= size.height; y += small) {
      final major = row % subdivisions == 0;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        major ? majorPaint : minorPaint,
      );
      row += 1;
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.spacing != spacing ||
        oldDelegate.subdivisions != subdivisions ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.majorLineColor != majorLineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.majorLineWidth != majorLineWidth;
  }
}
