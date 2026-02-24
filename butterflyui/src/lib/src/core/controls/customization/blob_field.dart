import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BlobFieldControl extends StatefulWidget {
  const _BlobFieldControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BlobFieldControl> createState() => _BlobFieldControlState();
}

class _BlobFieldControlState extends State<_BlobFieldControl> {
  late int _count;
  late int _seed;
  late Color _base;
  late Color _background;
  late double _minRadius;
  late double _maxRadius;
  late double _opacity;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BlobFieldControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps(widget.props);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'regenerate':
        setState(() {
          _seed = coerceOptionalInt(args['seed']) ?? DateTime.now().millisecondsSinceEpoch;
        });
        widget.sendEvent(widget.controlId, 'regenerated', {'seed': _seed});
        return _seed;
      case 'set_seed':
        final seed = coerceOptionalInt(args['seed']);
        if (seed != null) {
          setState(() {
            _seed = seed;
          });
        }
        return _seed;
      case 'set_progress':
        final value = coerceDouble(args['value']);
        if (value != null) {
          setState(() {
            _progress = value.clamp(0, 1).toDouble();
          });
        }
        return _progress;
      case 'set_playing':
        return args['value'] == true;
      default:
        throw UnsupportedError('Unknown blob_field method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlobPainter(
        count: _count,
        seed: _seed,
        base: _base,
        background: _background,
        minRadius: _minRadius,
        maxRadius: _maxRadius,
        opacity: _opacity,
        progress: _progress,
      ),
      child: const SizedBox.expand(),
    );
  }

  void _syncFromProps(Map<String, Object?> props) {
    _count = coerceOptionalInt(props['count']) ?? 12;
    _seed = coerceOptionalInt(props['seed']) ?? 7;
    _base = coerceColor(props['color']) ?? const Color(0xff8b5cf6);
    _background =
        coerceColor(props['background'] ?? props['bgcolor']) ?? Colors.transparent;
    _minRadius = coerceDouble(props['min_radius']) ?? 0.05;
    _maxRadius = coerceDouble(props['max_radius']) ?? 0.2;
    if (_maxRadius < _minRadius) {
      final temp = _minRadius;
      _minRadius = _maxRadius;
      _maxRadius = temp;
    }
    _opacity = (coerceDouble(props['opacity']) ?? 0.3).clamp(0, 1).toDouble();
    _progress = (coerceDouble(props['progress']) ?? 1).clamp(0, 1).toDouble();
  }
}

Widget buildBlobFieldControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BlobFieldControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _BlobPainter extends CustomPainter {
  final int count;
  final int seed;
  final Color base;
  final Color background;
  final double minRadius;
  final double maxRadius;
  final double opacity;
  final double progress;

  const _BlobPainter({
    required this.count,
    required this.seed,
    required this.base,
    required this.background,
    required this.minRadius,
    required this.maxRadius,
    required this.opacity,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = background;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final random = math.Random(seed);
    for (var i = 0; i < count; i += 1) {
      final minSide = math.min(size.width, size.height);
      final radius = (minSide * minRadius) + random.nextDouble() * (minSide * maxRadius);
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final alpha = (0.08 + random.nextDouble() * 0.22) * opacity * progress;

      final paint = Paint()
        ..color = base.withOpacity(alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.count != count ||
        oldDelegate.seed != seed ||
        oldDelegate.base != base ||
        oldDelegate.background != background ||
        oldDelegate.minRadius != minRadius ||
        oldDelegate.maxRadius != maxRadius ||
        oldDelegate.opacity != opacity ||
        oldDelegate.progress != progress;
  }
}
