import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRippleBurstControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _RippleBurstControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RippleBurstControl extends StatefulWidget {
  const _RippleBurstControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_RippleBurstControl> createState() => _RippleBurstControlState();
}

class _RippleBurstControlState extends State<_RippleBurstControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: coerceOptionalInt(widget.props['duration_ms']) ?? 500,
      ),
    );
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _RippleBurstControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final durationMs = coerceOptionalInt(widget.props['duration_ms']) ?? 500;
    _controller.duration = Duration(milliseconds: durationMs);
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
      case 'burst':
        await _playBurst();
        return null;
      case 'get_state':
        return <String, Object?>{'value': _controller.value};
      case 'emit':
        final event = (args['event'] ?? 'tap').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown ripple_burst method: $method');
    }
  }

  Future<void> _playBurst() async {
    if (!mounted) return;
    await _controller.forward(from: 0);
    if (!mounted || widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, 'burst', {'value': 1.0});
  }

  @override
  Widget build(BuildContext context) {
    final color = coerceColor(widget.props['color']) ??
        Theme.of(context).colorScheme.primary;
    final count = (coerceOptionalInt(widget.props['count']) ?? 3).clamp(1, 8);
    final maxRadius = coerceDouble(widget.props['max_radius']) ?? 90.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _playBurst,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            foregroundPainter: _RipplePainter(
              progress: _controller.value,
              color: color,
              count: count,
              maxRadius: maxRadius,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.progress,
    required this.color,
    required this.count,
    required this.maxRadius,
  });

  final double progress;
  final Color color;
  final int count;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < count; i += 1) {
      final t = (progress - (i / (count * 1.5))).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final radius = maxRadius * t;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (1.5 * (1 - t)).clamp(0.5, 1.5)
        ..color = color.withValues(alpha: (0.5 * (1 - t)).clamp(0.0, 0.5));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.count != count ||
        oldDelegate.maxRadius != maxRadius;
  }
}
