import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCurveEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CurveEditorControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CurveEditorControl extends StatefulWidget {
  const _CurveEditorControl({
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
  State<_CurveEditorControl> createState() => _CurveEditorControlState();
}

class _CurveEditorControlState extends State<_CurveEditorControl> {
  List<Map<String, Object?>> _points = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CurveEditorControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
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
    final raw = widget.props['points'];
    if (raw is List) {
      _points = raw.whereType<Map>().map((item) => coerceObjectMap(item)).toList(growable: false);
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_points':
        final raw = args['points'];
        if (raw is List) {
          setState(() {
            _points = raw.whereType<Map>().map((item) => coerceObjectMap(item)).toList(growable: false);
          });
          _emit('change', _statePayload());
        }
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
        throw UnsupportedError('Unknown curve_editor method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'points': _points};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final color = coerceColor(widget.props['color']) ?? Colors.cyan;
    final showGrid = widget.props['show_grid'] != false;
    final allowAdd = widget.props['allow_add'] == true;
    final height = coerceDouble(widget.props['height']) ?? 180;

    return GestureDetector(
      onTapDown: allowAdd
          ? (details) {
              final box = context.findRenderObject();
              if (box is! RenderBox || !box.hasSize) return;
              final p = details.localPosition;
              final x = (p.dx / box.size.width).clamp(0.0, 1.0);
              final y = (1 - (p.dy / box.size.height)).clamp(0.0, 1.0);
              final next = [..._points, <String, Object?>{'x': x, 'y': y}];
              setState(() => _points = next);
              _emit('change', _statePayload());
            }
          : null,
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _CurvePainter(points: _points, color: color, showGrid: showGrid),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  const _CurvePainter({required this.points, required this.color, required this.showGrid});

  final List<Map<String, Object?>> points;
  final Color color;
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final grid = Paint()..color = Colors.white12..strokeWidth = 1;
      for (var i = 1; i < 4; i += 1) {
        final dx = size.width * (i / 4);
        final dy = size.height * (i / 4);
        canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), grid);
        canvas.drawLine(Offset(0, dy), Offset(size.width, dy), grid);
      }
    }

    if (points.isEmpty) return;
    final sorted = [...points]..sort((a, b) => (coerceDouble(a['x']) ?? 0).compareTo(coerceDouble(b['x']) ?? 0));
    final path = Path();
    for (var i = 0; i < sorted.length; i += 1) {
      final x = (coerceDouble(sorted[i]['x']) ?? 0).clamp(0.0, 1.0) * size.width;
      final y = (1 - (coerceDouble(sorted[i]['y']) ?? 0).clamp(0.0, 1.0)) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
    }
    canvas.drawPath(path, Paint()..color = color..strokeWidth = 2..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color || oldDelegate.showGrid != showGrid;
  }
}
