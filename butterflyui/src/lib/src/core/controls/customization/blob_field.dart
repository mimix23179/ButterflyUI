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

  @override
  void initState() {
    super.initState();
    _count = coerceOptionalInt(widget.props['count']) ?? 12;
    _seed = coerceOptionalInt(widget.props['seed']) ?? 7;
    _base = coerceColor(widget.props['color']) ?? const Color(0xff8b5cf6);
    _background =
        coerceColor(widget.props['background'] ?? widget.props['bgcolor']) ??
            Colors.transparent;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BlobFieldControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
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
      ),
      child: const SizedBox.expand(),
    );
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

  const _BlobPainter({
    required this.count,
    required this.seed,
    required this.base,
    required this.background,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = background;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final random = math.Random(seed);
    for (var i = 0; i < count; i += 1) {
      final radius = (math.min(size.width, size.height) * 0.05) +
          random.nextDouble() * (math.min(size.width, size.height) * 0.2);
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final alpha = 0.08 + random.nextDouble() * 0.22;

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
        oldDelegate.background != background;
  }
}
