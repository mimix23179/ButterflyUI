import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSceneViewControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SceneViewControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SceneViewControl extends StatefulWidget {
  const _SceneViewControl({
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
  State<_SceneViewControl> createState() => _SceneViewControlState();
}

class _SceneViewControlState extends State<_SceneViewControl> {
  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SceneViewControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return <String, Object?>{
          'show_grid': widget.props['show_grid'] == true,
          'show_axes': widget.props['show_axes'] == true,
          'background': widget.props['background'],
        };
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown scene_view method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final showGrid = widget.props['show_grid'] == true;
    final showAxes = widget.props['show_axes'] == true;
    final backgroundColor = coerceColor(widget.props['background']) ??
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.45);

    final children = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        children.add(widget.buildChild(coerceObjectMap(raw)));
      }
    }

    return Container(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showGrid)
            IgnorePointer(
              child: CustomPaint(
                painter: _SceneGridPainter(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  step: coerceDouble(widget.props['grid_size']) ?? 24,
                ),
              ),
            ),
          if (showAxes)
            IgnorePointer(
              child: CustomPaint(
                painter: _AxesPainter(
                  xColor: Theme.of(context).colorScheme.primary,
                  yColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class _SceneGridPainter extends CustomPainter {
  const _SceneGridPainter({required this.color, required this.step});

  final Color color;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SceneGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.step != step;
  }
}

class _AxesPainter extends CustomPainter {
  const _AxesPainter({required this.xColor, required this.yColor});

  final Color xColor;
  final Color yColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final xPaint = Paint()..color = xColor.withValues(alpha: 0.9)..strokeWidth = 2;
    final yPaint = Paint()..color = yColor.withValues(alpha: 0.9)..strokeWidth = 2;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), xPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), yPaint);
  }

  @override
  bool shouldRepaint(covariant _AxesPainter oldDelegate) {
    return oldDelegate.xColor != xColor || oldDelegate.yColor != yColor;
  }
}
