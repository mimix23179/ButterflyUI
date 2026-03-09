import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BorderControl extends StatefulWidget {
  const _BorderControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?>) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BorderControl> createState() => _BorderControlState();
}

class _BorderControlState extends State<_BorderControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Color _color;
  late List<Color> _colors;
  late double _width;
  late double _radius;
  late String _side;
  late String _variant;
  late bool _animated;
  late int _durationMs;
  late bool _glow;
  late Color _glowColor;
  late double _dashLength;
  late double _dashGap;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _syncFromProps(widget.props, resetController: true);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BorderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _syncFromProps(widget.props);
      });
    }
  }

  void _syncFromProps(
    Map<String, Object?> props, {
    bool resetController = false,
  }) {
    _color =
        coerceColor(props['color'] ?? props['border_color']) ??
        const Color(0xff64748b);
    _colors = _coerceColors(props['colors'], _color);
    _width = coerceDouble(props['width'] ?? props['border_width']) ?? 1.4;
    _radius = coerceDouble(props['radius'] ?? props['border_radius']) ?? 0;
    _side = (props['side'] ?? 'all').toString().toLowerCase();
    _variant = (props['variant'] ?? props['style'] ?? 'solid')
        .toString()
        .toLowerCase();
    _durationMs =
        (coerceOptionalInt(props['duration_ms'] ?? props['duration']) ?? 1600)
            .clamp(1, 600000);
    _glow = props['glow'] == true || props['variant'] == 'glow';
    _glowColor = coerceColor(props['glow_color']) ?? _colors.first;
    _dashLength = coerceDouble(props['dash_length']) ?? 10.0;
    _dashGap = coerceDouble(props['dash_gap']) ?? 6.0;
    _animated =
        props['animated'] != false &&
        _variant != 'solid' &&
        _variant != 'static';

    _controller.duration = Duration(milliseconds: _durationMs);
    if (resetController) {
      _controller.value = 0.0;
    }
    if (_animated) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_style':
        setState(() {
          final merged = <String, Object?>{...widget.props, ...args};
          _syncFromProps(merged);
        });
        return null;
      default:
        throw UnsupportedError('Unknown border method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        coercePadding(widget.props['padding']) ?? const EdgeInsets.all(8);
    Widget child = const SizedBox.shrink();
    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      child = widget.buildChild(
        coerceObjectMap(widget.rawChildren.first as Map),
      );
    }

    child = wrapWithEffectRenderLayers(
      controlId: '${widget.controlId}::layers',
      props: widget.props,
      child: child,
    );

    Widget built = AnimatedBuilder(
      animation: _controller,
      child: Padding(padding: padding, child: child),
      builder: (context, renderedChild) {
        return CustomPaint(
          foregroundPainter: _EffectBorderPainter(
            color: _color,
            colors: _colors,
            width: _width,
            radius: _radius,
            side: _side,
            variant: _variant,
            progress: _controller.value,
            glow: _glow,
            glowColor: _glowColor,
            dashLength: _dashLength,
            dashGap: _dashGap,
          ),
          child: renderedChild,
        );
      },
    );

    if (_glow) {
      built = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _glowColor.withValues(alpha: 0.22),
              blurRadius: 18,
              spreadRadius: 0.8,
            ),
          ],
        ),
        child: built,
      );
    }

    return built;
  }
}

class _EffectBorderPainter extends CustomPainter {
  const _EffectBorderPainter({
    required this.color,
    required this.colors,
    required this.width,
    required this.radius,
    required this.side,
    required this.variant,
    required this.progress,
    required this.glow,
    required this.glowColor,
    required this.dashLength,
    required this.dashGap,
  });

  final Color color;
  final List<Color> colors;
  final double width;
  final double radius;
  final String side;
  final String variant;
  final double progress;
  final bool glow;
  final Color glowColor;
  final double dashLength;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final strokeRect = Offset.zero & size;
    final rect = strokeRect.deflate(width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (glow || variant == 'glow') {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    }

    switch (variant) {
      case 'rainbow':
        paint.shader = SweepGradient(
          colors: colors.length >= 3
              ? colors
              : <Color>[colors.first, glowColor, colors.last, colors.first],
          transform: GradientRotation(progress * math.pi * 2),
        ).createShader(rect);
        break;
      case 'water_flow':
      case 'flow':
        paint.shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors.length >= 2
              ? colors
              : <Color>[color, glowColor, color],
          stops: const <double>[0.0, 0.5, 1.0],
          transform: GradientRotation((progress * 0.6) - 0.2),
        ).createShader(rect);
        break;
      case 'pulse':
        final pulse = 0.45 + (math.sin(progress * math.pi * 2) + 1) * 0.275;
        paint.color = Color.lerp(color, glowColor, pulse.clamp(0.0, 1.0))!;
        break;
      case 'dashed':
        paint.color = color;
        _drawDashedPath(canvas, _buildPath(rect), paint);
        return;
      default:
        paint.color = color;
        break;
    }

    canvas.drawPath(_buildPath(rect), paint);
  }

  Path _buildPath(Rect rect) {
    final safeRadius = math.max(0.0, radius).toDouble();
    switch (side) {
      case 'top':
        return Path()
          ..moveTo(rect.left + safeRadius, rect.top)
          ..lineTo(rect.right - safeRadius, rect.top);
      case 'left':
        return Path()
          ..moveTo(rect.left, rect.top + safeRadius)
          ..lineTo(rect.left, rect.bottom - safeRadius);
      case 'right':
        return Path()
          ..moveTo(rect.right, rect.top + safeRadius)
          ..lineTo(rect.right, rect.bottom - safeRadius);
      case 'bottom':
        return Path()
          ..moveTo(rect.left + safeRadius, rect.bottom)
          ..lineTo(rect.right - safeRadius, rect.bottom);
      default:
        return Path()..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)),
        );
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EffectBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        width != oldDelegate.width ||
        radius != oldDelegate.radius ||
        side != oldDelegate.side ||
        variant != oldDelegate.variant ||
        progress != oldDelegate.progress ||
        glow != oldDelegate.glow ||
        glowColor != oldDelegate.glowColor ||
        dashLength != oldDelegate.dashLength ||
        dashGap != oldDelegate.dashGap ||
        colors.length != oldDelegate.colors.length;
  }
}

List<Color> _coerceColors(Object? raw, Color fallback) {
  if (raw is List) {
    final parsed = raw
        .map(coerceColor)
        .whereType<Color>()
        .toList(growable: false);
    if (parsed.isNotEmpty) {
      return parsed;
    }
  }
  return <Color>[
    fallback,
    Color.lerp(fallback, Colors.white, 0.35) ?? fallback,
    fallback,
  ];
}

Widget buildBorderControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _BorderControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
