import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _AnimatedGradientControl extends StatefulWidget {
  const _AnimatedGradientControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?>) buildChild;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_AnimatedGradientControl> createState() => _AnimatedGradientControlState();
}

class _AnimatedGradientControlState extends State<_AnimatedGradientControl> {
  late List<Color> _colors;
  late int _durationMs;
  late double _radius;

  @override
  void initState() {
    super.initState();
    _colors = _coerceColors(widget.props['colors']);
    _durationMs =
        coerceOptionalInt(widget.props['duration_ms'] ?? widget.props['duration']) ??
            280;
    _radius = coerceDouble(widget.props['radius']) ?? 0;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _AnimatedGradientControl oldWidget) {
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
      case 'get_state':
        return {
          'colors': _colors.map((color) => color.value).toList(growable: false),
          'duration_ms': _durationMs,
          'radius': _radius,
        };
      case 'set_colors':
        setState(() {
          _colors = _coerceColors(args['colors']);
        });
        widget.sendEvent(widget.controlId, 'change', {
          'colors': _colors.map((color) => color.value).toList(growable: false),
        });
        return null;
      default:
        throw UnsupportedError('Unknown animated_gradient method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final begin = _alignmentFrom(widget.props['begin']) ?? Alignment.topLeft;
    final end = _alignmentFrom(widget.props['end']) ?? Alignment.bottomRight;
    Widget child = const SizedBox.expand();
    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      child = widget.buildChild(coerceObjectMap(widget.rawChildren.first as Map));
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: _durationMs),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors, begin: begin, end: end),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: child,
    );
  }
}

List<Color> _coerceColors(Object? colorsRaw) {
  final colors = <Color>[];
  if (colorsRaw is List) {
    for (final item in colorsRaw) {
      final color = coerceColor(item);
      if (color != null) {
        colors.add(color);
      }
    }
  }
  if (colors.length < 2) {
    colors
      ..clear()
      ..add(const Color(0xff7c3aed))
      ..add(const Color(0xff06b6d4));
  }
  return colors;
}

Widget buildAnimatedGradientControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AnimatedGradientControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

Alignment? _alignmentFrom(Object? value) {
  if (value is List && value.length >= 2) {
    return Alignment(
      (value[0] as num?)?.toDouble() ?? 0,
      (value[1] as num?)?.toDouble() ?? 0,
    );
  }
  if (value is Map) {
    return Alignment(
      (value['x'] as num?)?.toDouble() ?? 0,
      (value['y'] as num?)?.toDouble() ?? 0,
    );
  }
  switch (value?.toString().toLowerCase().replaceAll(' ', '_')) {
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_right':
      return Alignment.bottomRight;
    case 'center':
      return Alignment.center;
  }
  return null;
}
