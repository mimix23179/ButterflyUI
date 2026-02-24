import 'package:flutter/material.dart';
import 'dart:math' as math;

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

class _AnimatedGradientControlState extends State<_AnimatedGradientControl>
  with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  late List<Color> _colors;
  List<double>? _stops;
  late int _durationMs;
  late double _radius;
  late double _angle;
  late bool _loop;
  late bool _playing;
  late bool _pingPong;
  late bool _shift;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props, resetController: true);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _AnimatedGradientControl oldWidget) {
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
    _controller.dispose();
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props, {bool resetController = false}) {
    _colors = _coerceColors(props['colors']);
    _stops = _coerceStops(props['stops'], _colors.length);
    _durationMs =
        coerceOptionalInt(props['duration_ms'] ?? props['duration']) ?? 1800;
    _radius = coerceDouble(props['radius']) ?? 0;
    _angle = coerceDouble(props['angle'] ?? props['start_angle']) ?? 0;
    _loop = props['loop'] != false;
    _playing = props['playing'] == true || props['play'] == true || props['autoplay'] != false;
    _pingPong = props['ping_pong'] == true;
    _shift = props['shift'] == true;

    _controller.duration = Duration(milliseconds: _durationMs.clamp(1, 600000));
    if (resetController) {
      _controller.value = 0;
    }
    if (_playing) {
      if (_loop) {
        _controller.repeat(reverse: _pingPong);
      } else {
        _controller.forward(from: _controller.value);
      }
    } else {
      _controller.stop();
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {
          'colors': _colors.map((color) => '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}').toList(growable: false),
          'stops': _stops,
          'duration_ms': _durationMs,
          'radius': _radius,
          'angle': _angle,
          'playing': _playing,
        };
      case 'set_colors':
        setState(() {
          _colors = _coerceColors(args['colors']);
          _stops = _coerceStops(args['stops'], _colors.length) ?? _stops;
        });
        widget.sendEvent(widget.controlId, 'change', {
          'colors': _colors.map((color) => '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}').toList(growable: false),
        });
        return null;
      case 'set_stops':
        setState(() {
          _stops = _coerceStops(args['stops'], _colors.length);
        });
        return _stops;
      case 'set_angle':
        final next = coerceDouble(args['angle']);
        if (next != null) {
          setState(() => _angle = next);
        }
        return _angle;
      case 'play':
        _playing = true;
        if (_loop) {
          _controller.repeat(reverse: _pingPong);
        } else {
          _controller.forward(from: _controller.value);
        }
        return true;
      case 'pause':
        _playing = false;
        _controller.stop();
        return true;
      default:
        throw UnsupportedError('Unknown animated_gradient method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final begin = _alignmentFrom(widget.props['begin']) ?? Alignment.topLeft;
    final end = _alignmentFrom(widget.props['end']) ?? Alignment.bottomRight;
    final center = _alignmentFrom(widget.props['center']) ?? Alignment.center;
    final variant = (widget.props['variant'] ?? widget.props['kind'] ?? widget.props['type'])
        ?.toString()
        .toLowerCase();
    Widget child = const SizedBox.expand();
    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      child = widget.buildChild(coerceObjectMap(widget.rawChildren.first as Map));
    }

    return AnimatedBuilder(
      animation: _controller,
      child: child,
      builder: (context, renderedChild) {
        final progress = _controller.value;
        final rotation = ((_angle * math.pi) / 180.0) + (progress * 2 * math.pi);
        final shiftedColors = _shift ? _rotateColors(_colors, progress) : _colors;
        final stops = _coerceStops(_stops, shiftedColors.length);
        final gradient = switch (variant) {
          'radial' || 'radial_gradient' => RadialGradient(
              colors: shiftedColors,
              stops: stops,
              center: center,
              radius: coerceDouble(widget.props['radius']) ?? 0.8,
              tileMode: _tileMode(widget.props['tile_mode']),
            ),
          'sweep' || 'conic' || 'sweep_gradient' => SweepGradient(
              colors: shiftedColors,
              stops: stops,
              center: center,
              startAngle: (coerceDouble(widget.props['start_angle']) ?? 0) * math.pi / 180,
              endAngle: (coerceDouble(widget.props['end_angle']) ?? 360) * math.pi / 180,
              transform: GradientRotation(rotation),
              tileMode: _tileMode(widget.props['tile_mode']),
            ),
          _ => LinearGradient(
              colors: shiftedColors,
              stops: stops,
              begin: begin,
              end: end,
              transform: GradientRotation(rotation),
              tileMode: _tileMode(widget.props['tile_mode']),
            ),
        };

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: renderedChild,
        );
      },
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

List<double>? _coerceStops(Object? raw, int colorCount) {
  if (colorCount < 2) return null;
  if (raw is! List) return null;
  final parsed = raw
      .map(coerceDouble)
      .whereType<double>()
      .map((value) => value.clamp(0.0, 1.0))
      .toList(growable: false);
  if (parsed.length != colorCount) return null;
  return parsed;
}

List<Color> _rotateColors(List<Color> colors, double progress) {
  if (colors.length < 2) return colors;
  final offset = ((progress * colors.length).floor()) % colors.length;
  if (offset == 0) return colors;
  return [
    ...colors.sublist(offset),
    ...colors.sublist(0, offset),
  ];
}

TileMode _tileMode(Object? raw) {
  switch (raw?.toString().toLowerCase()) {
    case 'repeated':
    case 'repeat':
      return TileMode.repeated;
    case 'mirror':
      return TileMode.mirror;
    case 'decal':
      return TileMode.decal;
    case 'clamp':
    default:
      return TileMode.clamp;
  }
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
