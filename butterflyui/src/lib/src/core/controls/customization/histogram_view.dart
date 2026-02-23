import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildHistogramViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _HistogramViewControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _HistogramViewControl extends StatefulWidget {
  const _HistogramViewControl({
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
  State<_HistogramViewControl> createState() => _HistogramViewControlState();
}

class _HistogramViewControlState extends State<_HistogramViewControl> {
  List<double> _bins = const <double>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _HistogramViewControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    _syncFromProps();
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _bins = _coerceBins(widget.props['bins']);
  }

  List<double> _coerceBins(Object? value) {
    if (value is! List) return const <double>[];
    return value.map((v) => (coerceDouble(v) ?? 0).clamp(0.0, double.infinity)).toList(growable: false);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_bins':
        setState(() {
          _bins = _coerceBins(args['bins']);
        });
        _emit('change', _statePayload());
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
        throw UnsupportedError('Unknown histogram_view method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'bins': _bins};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.props['compact'] == true;
    final showGrid = widget.props['show_grid'] != false;
    final height = coerceDouble(widget.props['height']) ?? (compact ? 84 : 140);
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _HistogramPainter(
          bins: _bins,
          color: coerceColor(widget.props['color']) ?? const Color(0xff60a5fa),
          showGrid: showGrid,
        ),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  const _HistogramPainter({required this.bins, required this.color, required this.showGrid});

  final List<double> bins;
  final Color color;
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final grid = Paint()..color = Colors.white12..strokeWidth = 1;
      for (var i = 1; i < 4; i += 1) {
        final y = size.height * (i / 4);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      }
    }

    if (bins.isEmpty) return;
    final maxValue = bins.reduce(math.max);
    if (maxValue <= 0) return;

    final barWidth = size.width / bins.length;
    final paint = Paint()..color = color;
    for (var i = 0; i < bins.length; i += 1) {
      final h = (bins[i] / maxValue) * size.height;
      final rect = Rect.fromLTWH(i * barWidth, size.height - h, barWidth * 0.88, h);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HistogramPainter oldDelegate) {
    return oldDelegate.bins != bins || oldDelegate.color != color || oldDelegate.showGrid != showGrid;
  }
}
