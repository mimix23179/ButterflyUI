import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRulersOverlayControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _RulersOverlayControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RulersOverlayControl extends StatefulWidget {
  const _RulersOverlayControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_RulersOverlayControl> createState() => _RulersOverlayControlState();
}

class _RulersOverlayControlState extends State<_RulersOverlayControl> {
  List<double> _guidesX = const <double>[];
  List<double> _guidesY = const <double>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _RulersOverlayControl oldWidget) {
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
    _guidesX = _coerce(widget.props['guides_x']);
    _guidesY = _coerce(widget.props['guides_y']);
  }

  List<double> _coerce(Object? value) {
    if (value is! List) return const <double>[];
    return value.map((v) => coerceDouble(v) ?? 0.0).toList(growable: false);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_guides':
        setState(() {
          _guidesX = _coerce(args['guides_x']);
          _guidesY = _coerce(args['guides_y']);
        });
        _emit('change', {'guides_x': _guidesX, 'guides_y': _guidesY});
        return {'guides_x': _guidesX, 'guides_y': _guidesY};
      case 'get_state':
        return {'guides_x': _guidesX, 'guides_y': _guidesY};
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown rulers_overlay method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final showRulers = widget.props['show_rulers'] == null || widget.props['show_rulers'] == true;
    final showGrid = widget.props['show_grid'] == true;
    final gridSize = coerceDouble(widget.props['grid_size']) ?? 16.0;

    Map<String, Object?>? childMap;
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        childMap = coerceObjectMap(raw);
        break;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final rulerSize = showRulers ? 20.0 : 0.0;

        return Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: rulerSize, top: rulerSize),
                child: childMap == null
                    ? const SizedBox.shrink()
                    : widget.buildChild(childMap),
              ),
            ),
            if (showGrid)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GridPainter(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      gridSize: gridSize,
                      offsetX: rulerSize,
                      offsetY: rulerSize,
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GuidePainter(
                    guidesX: _guidesX,
                    guidesY: _guidesY,
                    color: Theme.of(context).colorScheme.primary,
                    offsetX: rulerSize,
                    offsetY: rulerSize,
                    width: width,
                    height: height,
                  ),
                ),
              ),
            ),
            if (showRulers)
              Positioned(
                left: rulerSize,
                right: 0,
                top: 0,
                height: rulerSize,
                child: CustomPaint(
                  painter: _RulerPainter(horizontal: true),
                ),
              ),
            if (showRulers)
              Positioned(
                left: 0,
                top: rulerSize,
                bottom: 0,
                width: rulerSize,
                child: CustomPaint(
                  painter: _RulerPainter(horizontal: false),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RulerPainter extends CustomPainter {
  const _RulerPainter({required this.horizontal});

  final bool horizontal;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.08);
    canvas.drawRect(Offset.zero & size, paint);

    final tickPaint = Paint()..color = Colors.black.withOpacity(0.35)..strokeWidth = 1;
    const step = 10.0;
    final limit = horizontal ? size.width : size.height;
    for (double v = 0; v <= limit; v += step) {
      final longTick = (v % 50) == 0;
      if (horizontal) {
        canvas.drawLine(
          Offset(v, size.height),
          Offset(v, size.height - (longTick ? 10 : 6)),
          tickPaint,
        );
      } else {
        canvas.drawLine(
          Offset(size.width, v),
          Offset(size.width - (longTick ? 10 : 6), v),
          tickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return oldDelegate.horizontal != horizontal;
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.color,
    required this.gridSize,
    required this.offsetX,
    required this.offsetY,
  });

  final Color color;
  final double gridSize;
  final double offsetX;
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    for (double x = offsetX; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, offsetY), Offset(x, size.height), paint);
    }
    for (double y = offsetY; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(offsetX, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY;
  }
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter({
    required this.guidesX,
    required this.guidesY,
    required this.color,
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });

  final List<double> guidesX;
  final List<double> guidesY;
  final Color color;
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.7)..strokeWidth = 1;
    for (final x in guidesX) {
      final dx = (x + offsetX).clamp(offsetX, width).toDouble();
      canvas.drawLine(Offset(dx, offsetY), Offset(dx, height), paint);
    }
    for (final y in guidesY) {
      final dy = (y + offsetY).clamp(offsetY, height).toDouble();
      canvas.drawLine(Offset(offsetX, dy), Offset(width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GuidePainter oldDelegate) {
    return oldDelegate.guidesX != guidesX ||
        oldDelegate.guidesY != guidesY ||
        oldDelegate.color != color ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
