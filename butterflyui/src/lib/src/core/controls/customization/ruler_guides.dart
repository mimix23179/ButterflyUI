import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRulerGuidesControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _RulerGuidesControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RulerGuidesControl extends StatefulWidget {
  const _RulerGuidesControl({
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
  State<_RulerGuidesControl> createState() => _RulerGuidesControlState();
}

class _RulerGuidesControlState extends State<_RulerGuidesControl> {
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
  void didUpdateWidget(covariant _RulerGuidesControl oldWidget) {
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
        throw UnsupportedError('Unknown ruler_guides method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.props['visible'] == null || widget.props['visible'] == true;
    if (!visible) return const SizedBox.shrink();

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _RulerGuidesPainter(
              guidesX: _guidesX,
              guidesY: _guidesY,
              color: coerceColor(widget.props['color']) ?? Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}

class _RulerGuidesPainter extends CustomPainter {
  const _RulerGuidesPainter({
    required this.guidesX,
    required this.guidesY,
    required this.color,
  });

  final List<double> guidesX;
  final List<double> guidesY;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 1;

    for (final x in guidesX) {
      final dx = x.clamp(0, size.width).toDouble();
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }
    for (final y in guidesY) {
      final dy = y.clamp(0, size.height).toDouble();
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RulerGuidesPainter oldDelegate) {
    return oldDelegate.guidesX != guidesX ||
        oldDelegate.guidesY != guidesY ||
        oldDelegate.color != color;
  }
}
