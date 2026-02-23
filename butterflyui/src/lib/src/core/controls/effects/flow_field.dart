import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFlowFieldControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FlowFieldControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _FlowFieldControl extends StatefulWidget {
  const _FlowFieldControl({
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
  State<_FlowFieldControl> createState() => _FlowFieldControlState();
}

class _FlowFieldControlState extends State<_FlowFieldControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _seed;

  @override
  void initState() {
    super.initState();
    _seed = coerceOptionalInt(widget.props['seed']) ?? 1;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..repeat();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _FlowFieldControl oldWidget) {
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
      _seed = coerceOptionalInt(widget.props['seed']) ?? _seed;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return _statePayload();
      case 'set_props':
        if (args['props'] is Map) {
          final map = coerceObjectMap(args['props'] as Map);
          setState(() {
            _seed = coerceOptionalInt(map['seed']) ?? _seed;
          });
          _emit('change', _statePayload());
        }
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown flow_field method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'seed': _seed};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final density = (coerceDouble(widget.props['density']) ?? 24).clamp(8.0, 120.0);
    final speed = (coerceDouble(widget.props['speed']) ?? 0.35).clamp(0.0, 5.0);
    final lineWidth = (coerceDouble(widget.props['line_width']) ?? 1.1).clamp(0.2, 8.0);
    final opacity = (coerceDouble(widget.props['opacity']) ?? 0.6).clamp(0.0, 1.0);
    final color = (coerceColor(widget.props['color']) ?? const Color(0xff22d3ee)).withValues(alpha: opacity);

    Widget? child;
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _FlowFieldPainter(
            t: _controller.value,
            seed: _seed,
            density: density,
            speed: speed,
            lineWidth: lineWidth,
            color: color,
          ),
          child: child,
        );
      },
    );
  }
}

class _FlowFieldPainter extends CustomPainter {
  const _FlowFieldPainter({
    required this.t,
    required this.seed,
    required this.density,
    required this.speed,
    required this.lineWidth,
    required this.color,
  });

  final double t;
  final int seed;
  final double density;
  final double speed;
  final double lineWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final cols = math.max(1, (size.width / density).floor());
    final rows = math.max(1, (size.height / density).floor());
    final scale = speed * math.pi * 2;

    for (var y = 0; y <= rows; y += 1) {
      for (var x = 0; x <= cols; x += 1) {
        final px = x * density;
        final py = y * density;
        final n = math.sin((x * 0.43) + (y * 0.31) + seed * 0.017 + t * scale);
        final angle = n * math.pi;
        final len = density * 0.42;
        final dx = math.cos(angle) * len;
        final dy = math.sin(angle) * len;
        canvas.drawLine(Offset(px, py), Offset(px + dx, py + dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FlowFieldPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.seed != seed ||
        oldDelegate.density != density ||
        oldDelegate.speed != speed ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.color != color;
  }
}
