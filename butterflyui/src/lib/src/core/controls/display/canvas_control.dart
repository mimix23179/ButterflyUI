import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCanvasControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CanvasControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CanvasControl extends StatefulWidget {
  const _CanvasControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_CanvasControl> createState() => _CanvasControlState();
}

class _CanvasControlState extends State<_CanvasControl> {
  List<Map<String, Object?>> _shapes = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CanvasControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _shapes = _coerceShapes(widget.props['shapes'] ?? widget.props['strokes']);
  }

  List<Map<String, Object?>> _coerceShapes(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final item in raw) {
      if (item is Map) out.add(coerceObjectMap(item));
    }
    return out;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_shapes':
        final next = _coerceShapes(args['shapes']);
        setState(() => _shapes = next);
        _emit('change', _statePayload());
        return _statePayload();
      case 'clear':
        setState(() => _shapes = const <Map<String, Object?>>[]);
        _emit('clear', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown canvas method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'shapes': _shapes, 'count': _shapes.length};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final bg = coerceColor(widget.props['background']);
    final height = coerceDouble(widget.props['height']) ?? 220;
    return GestureDetector(
      onTapDown: (details) {
        _emit('tap', {
          'x': details.localPosition.dx,
          'y': details.localPosition.dy,
          ..._statePayload(),
        });
      },
      child: Container(
        color: bg,
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _SimpleCanvasPainter(_shapes),
        ),
      ),
    );
  }
}

class _SimpleCanvasPainter extends CustomPainter {
  const _SimpleCanvasPainter(this.shapes);

  final List<Map<String, Object?>> shapes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      final type = (shape['type'] ?? 'line').toString().toLowerCase();
      final color = coerceColor(shape['color']) ?? Colors.blue;
      final stroke = (coerceDouble(shape['stroke']) ?? 2).clamp(0.5, 64).toDouble();
      final paint = Paint()
        ..color = color
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke;

      if (type == 'rect') {
        final x = coerceDouble(shape['x']) ?? 0;
        final y = coerceDouble(shape['y']) ?? 0;
        final w = coerceDouble(shape['width']) ?? 10;
        final h = coerceDouble(shape['height']) ?? 10;
        canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
      } else if (type == 'circle') {
        final x = coerceDouble(shape['x']) ?? 0;
        final y = coerceDouble(shape['y']) ?? 0;
        final r = coerceDouble(shape['radius']) ?? 5;
        canvas.drawCircle(Offset(x, y), r, paint);
      } else {
        final x1 = coerceDouble(shape['x1']) ?? coerceDouble(shape['x']) ?? 0;
        final y1 = coerceDouble(shape['y1']) ?? coerceDouble(shape['y']) ?? 0;
        final x2 = coerceDouble(shape['x2']) ?? x1 + 20;
        final y2 = coerceDouble(shape['y2']) ?? y1 + 20;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SimpleCanvasPainter oldDelegate) {
    return oldDelegate.shapes != shapes;
  }
}
